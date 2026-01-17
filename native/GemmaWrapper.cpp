#define HL_NAME(n) gemma_##n
#include <hl.h>
#include "GemmaWrapper.h"
#include "llama.h"
#include <vector>
#include <string>
#include <cstring>
#include <iostream>
#include <sstream>

// ----------------------------------------------------------------
// Globals
// ----------------------------------------------------------------
static llama_model* model = nullptr;
static llama_context* ctx = nullptr;
static int n_ctx = 0;
static int n_past = 0;

// Store params to re-use during reset
static llama_context_params ctx_params_global;

// ----------------------------------------------------------------
// Helpers
// ----------------------------------------------------------------

void safe_batch_add(llama_batch & batch, llama_token id, llama_pos pos, const std::vector<llama_seq_id> & seq_ids, bool logits) {
    batch.token   [batch.n_tokens] = id;
    batch.pos     [batch.n_tokens] = pos;
    batch.n_seq_id[batch.n_tokens] = seq_ids.size();

    for (size_t i = 0; i < seq_ids.size(); ++i) {
        batch.seq_id[batch.n_tokens][i] = seq_ids[i];
    }

    batch.logits  [batch.n_tokens] = logits ? 1 : 0;
    batch.n_tokens++;
}

static bool is_eos(const llama_model * model, llama_token t) {
    const llama_vocab * vocab = llama_model_get_vocab(model);
    return t == llama_vocab_eos(vocab) || t == llama_vocab_eot(vocab);
}

// ----------------------------------------------------------------
// Wrapper Implementation
// ----------------------------------------------------------------

void GemmaWrapper::init(const char* model_path) {
    // Cleanup if re-initializing
    if (ctx) llama_free(ctx);
    if (model) llama_model_free(model);

    // Load Model
    llama_model_params model_params = llama_model_default_params();
    model = llama_model_load_from_file(model_path, model_params);

    if (!model) {
        fprintf(stderr, "[GemmaWrapper] Error: Failed to load model from %s\n", model_path);
        return;
    }

    // Setup Context Params (and store them for reset)
    ctx_params_global = llama_context_default_params();
    ctx_params_global.n_ctx = 32768;
    ctx_params_global.n_batch = 2048;
    ctx_params_global.n_threads = 4;
    ctx_params_global.n_threads_batch = 4;

    // Create Context
    ctx = llama_init_from_model(model, ctx_params_global);
    if (!ctx) {
        fprintf(stderr, "[GemmaWrapper] Error: Failed to create context\n");
        return;
    }

    n_ctx = llama_n_ctx(ctx);
    n_past = 0;
}

void GemmaWrapper::reset() {
    // ROBUST RESET: Instead of relying on fluctuating KV cache APIs,
    // we simply destroy and recreate the context. This is 100% safe.
    if(ctx) {
        llama_free(ctx);
        ctx = nullptr;
    }

    if(model) {
        ctx = llama_init_from_model(model, ctx_params_global);
        if (ctx) {
            n_ctx = llama_n_ctx(ctx);
            printf("[GemmaWrapper] Context Re-initialized.\n");
        } else {
            fprintf(stderr, "[GemmaWrapper] Error: Failed to re-init context during reset\n");
        }
    }

    n_past = 0;
}

const char* GemmaWrapper::query(const char* prompt_text) {
    if (!model) return "Error: Model not initialized";
    char formattedPrompt[strlen(prompt_text)+50];
    snprintf(formattedPrompt, sizeof(formattedPrompt), "%s%s%s", "<start_of_turn>user\n", prompt_text, "<end_of_turn>\n");
    // 1. Reset (Stateless)
    reset();
    if (!ctx) return "Error: Context failed to reset";

    const llama_vocab * vocab = llama_model_get_vocab(model);

    // ----------------------------------------------------------------
    // 2. Robust Tokenization Strategy
    // ----------------------------------------------------------------
    std::vector<llama_token> final_tokens;

    // A. Tokenize the User Input (Standard)
    //    We use add_bos = true because this is the start of the sequence.
    int n_input = -llama_tokenize(vocab, formattedPrompt, strlen(formattedPrompt), NULL, 0, true, true);
    std::vector<llama_token> input_tokens(n_input);
    llama_tokenize(vocab, formattedPrompt, strlen(formattedPrompt), input_tokens.data(), n_input, true, true);

    final_tokens.insert(final_tokens.end(), input_tokens.begin(), input_tokens.end());

    // B. Force-Append the Trigger (The Fix)
    //    We tokenize just the trigger phrase separately to ensure it exists.
    const char* trigger_text = "<start_of_turn>model\n";
    int n_trigger = -llama_tokenize(vocab, trigger_text, strlen(trigger_text), NULL, 0, false, true);
    std::vector<llama_token> trigger_tokens(n_trigger);
    llama_tokenize(vocab, trigger_text, strlen(trigger_text), trigger_tokens.data(), n_trigger, false, true);

    final_tokens.insert(final_tokens.end(), trigger_tokens.begin(), trigger_tokens.end());

    // ----------------------------------------------------------------
    // 3. Decode
    // ----------------------------------------------------------------
    llama_batch batch = llama_batch_init(2048, 0, 1);

    // Process the combined tokens
    for (size_t i = 0; i < final_tokens.size(); i++) {
        if (batch.n_tokens >= 2048) {
            llama_decode(ctx, batch);
            batch.n_tokens = 0;
        }

        bool output_logits = (i == final_tokens.size() - 1);
        safe_batch_add(batch, final_tokens[i], n_past, { 0 }, output_logits);
        n_past++;
    }

    if (batch.n_tokens > 0) llama_decode(ctx, batch);

    // ----------------------------------------------------------------
    // 4. Generate
    // ----------------------------------------------------------------
    llama_sampler * smpl = llama_sampler_chain_init(llama_sampler_chain_default_params());
    llama_sampler_chain_add(smpl, llama_sampler_init_penalties(64, 1.1f, 0.0f, 0.0f));
    llama_sampler_chain_add(smpl, llama_sampler_init_top_k(40));
    llama_sampler_chain_add(smpl, llama_sampler_init_top_p(0.95f, 1));
    llama_sampler_chain_add(smpl, llama_sampler_init_temp(0.8f));
    llama_sampler_chain_add(smpl, llama_sampler_init_dist(1234));

    static std::string result_str;
    result_str.clear();

    for (int i = 0; i < 512; i++) {
        llama_token new_token_id = llama_sampler_sample(smpl, ctx, -1);
        if (is_eos(model, new_token_id)) break;
        llama_sampler_accept(smpl, new_token_id);

        char buf[256];
        int n = llama_token_to_piece(vocab, new_token_id, buf, sizeof(buf), 0, true);

        if (n >= 0) {
            std::string piece(buf, n);
            if (piece.find("<end_of_turn>") != std::string::npos) break;

            result_str += piece;
            printf("%s", piece.c_str());
            fflush(stdout);
        }

        batch.n_tokens = 0;
        safe_batch_add(batch, new_token_id, n_past, { 0 }, true);
        n_past++;

        if (llama_decode(ctx, batch) != 0) break;
    }

    llama_sampler_free(smpl);
    llama_batch_free(batch);

    return result_str.c_str();
}

// ---------------------------------------------------------
// HashLink Glue Code
// ---------------------------------------------------------
// extern "C" {

//     void gemma_init(vbyte* model_path) {
//         GemmaWrapper::init((char*)model_path);
//     }

//     void gemma_reset() {
//         GemmaWrapper::reset();
//     }

//     vbyte* gemma_query(vbyte* prompt) {
//         const char* result_c_str = GemmaWrapper::query((char*)prompt);
//         int len = (int)strlen(result_c_str);
//         vbyte* hl_mem = (vbyte*)hl_alloc_bytes(len + 1);
//         memcpy(hl_mem, result_c_str, len + 1);
//         return hl_mem;
//     }
// }
// ---------------------------------------------------------
// HashLink Glue Code
// ---------------------------------------------------------
extern "C" {

    // 1. INIT
    HL_PRIM void HL_NAME(init)(vbyte* model_path) {
        GemmaWrapper::init((char*)model_path);
    }
    // Registers function 'init' taking (_BYTES) and returning (_VOID)
    DEFINE_PRIM(_VOID, init, _BYTES);


    // 2. RESET
    HL_PRIM void HL_NAME(reset)() {
        GemmaWrapper::reset();
    }
    // Registers function 'reset' taking no args and returning (_VOID)
    DEFINE_PRIM(_VOID, reset, _NO_ARG);


    // 3. QUERY
    HL_PRIM vbyte* HL_NAME(query)(vbyte* prompt) {
        const char* result_c_str = GemmaWrapper::query((char*)prompt);

        // HashLink string allocation
        int len = (int)strlen(result_c_str);
        char* hl_mem = (char*)hl_alloc_bytes(len + 1);
        memcpy(hl_mem, result_c_str, len + 1);

        return (vbyte*)hl_mem;
    }
    // Registers function 'query' taking (_BYTES) and returning (_BYTES)
    DEFINE_PRIM(_BYTES, query, _BYTES);

}
