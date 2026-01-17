# --- CONFIGURATION ---
# llama.ccp relative path must be in same directory at this project
LLAMA_PATH = ../llama.cpp
HL_INCLUDE = /usr/local/include
OUTPUT_LIB = gemma.hdll

# Compiler Settings
CXX = g++
CXXFLAGS = -O3 -std=c++17 -shared -fPIC -I$(HL_INCLUDE) -I$(LLAMA_PATH)/include -I$(LLAMA_PATH)/ggml/include -I$(shell haxelib libpath hashlink)src

# Libraries (Static Llama libs + System libs)
# Note: We link static libs (.a) into our shared lib (.hdll).
# This requires that llama.cpp was compiled with -fPIC.
LIBS = -Wl,--start-group \
       $(LLAMA_PATH)/build/src/libllama.a \
       $(LLAMA_PATH)/build/ggml/src/libggml.a \
       $(LLAMA_PATH)/build/ggml/src/libggml-cpu.a \
       $(LLAMA_PATH)/build/ggml/src/libggml-base.a \
       -Wl,--end-group \
       -lstdc++ -fopenmp

# Source Files
SRC = native/GemmaWrapper.cpp

# --- TARGETS ---

# Default target: Build the DLL if source changed
all: $(OUTPUT_LIB)

# The Rule: Only rebuild gemma.hdll if GemmaWrapper.cpp changes
$(OUTPUT_LIB): $(SRC)
	@echo " [C++] Compiling Gemma Native Extension..."
	$(CXX) $(CXXFLAGS) $(SRC) -o $(OUTPUT_LIB) $(LIBS)
	@echo " [SUCCESS] Created $(OUTPUT_LIB)"

clean:
	rm -f $(OUTPUT_LIB)
