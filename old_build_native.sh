#!/bin/bash

# --- CONFIGURATION ---
LLAMA_PATH="/home/apparition/git/llama.cpp"
HL_INCLUDE="/usr/local/include" 
HL_LIB_PATH="/usr/local/lib"

# Define Libs
LIB_LLAMA="$LLAMA_PATH/build/src/libllama.a"
LIB_GGML="$LLAMA_PATH/build/ggml/src/libggml.a"
LIB_GGML_CPU="$LLAMA_PATH/build/ggml/src/ggml-cpu/libggml-cpu.a"
LIB_GGML_BASE="$LLAMA_PATH/build/ggml/src/libggml-base.a"
HL_EXTS="$HL_LIB_PATH/fmt.hdll $HL_LIB_PATH/sdl.hdll $HL_LIB_PATH/ui.hdll $HL_LIB_PATH/uv.hdll $HL_LIB_PATH/openal.hdll"
SYS_LIBS="-lSDL2 -lGL -lopenal -lpng -ljpeg -lz -luv -lvorbisfile -lvorbis -logg -lmbedtls -lmbedcrypto"

# Prepare
mkdir -p out

# --- 1. CAPTURE OLD CHECKSUM ---
# We hash ALL .c files in output to detect changes in logic, not just the entry point.
if [ -d "out" ]; then
    OLD_HASH=$(find out -name "*.c" -type f -exec md5sum {} + | sort | md5sum | awk '{ print $1 }')
else
    OLD_HASH=""
fi

# --- 2. RUN HAXE ---
echo "Generating Haxe code..."
if haxe build.hxml -D LLAMA_PATH="$LLAMA_PATH"; then
    echo "Haxe generation successful."
else
    echo "Haxe failed. Stop."
    exit 1
fi

# --- 3. CAPTURE NEW CHECKSUM ---
NEW_HASH=$(find out -name "*.c" -type f -exec md5sum {} + | sort | md5sum | awk '{ print $1 }')

# --- 4. COMPILE C (Only if Hash changed) ---
DO_LINK=false

# We compile if:
# A) The file content changed (Hashes don't match)
# B) We never compiled it before (main.o missing)
if [ "$OLD_HASH" != "$NEW_HASH" ] || [ ! -f "out/main.o" ]; then
    echo "Creating new object file (Content changed)..."
    # Using -Og for speed. Change to -O3 for final release.
    gcc -Og -c out/main.c -o out/main.o \
        -I out/ \
        -I $HL_INCLUDE \
        -Wno-permissive
    
    if [ $? -ne 0 ]; then echo "GCC Failed"; exit 1; fi
    DO_LINK=true
else
    echo "Haxe C output is identical. Skipping GCC."
fi

# --- 5. COMPILE WRAPPER (Standard Timestamp Check) ---
if [ ! -f "native/GemmaWrapper.o" ] || [ "native/GemmaWrapper.cpp" -nt "native/GemmaWrapper.o" ]; then
    echo "Compiling C++ Wrapper..."
    g++ -Og -c native/GemmaWrapper.cpp -o native/GemmaWrapper.o \
        -std=c++17 \
        -I native/ \
        -I $LLAMA_PATH/include \
        -I $LLAMA_PATH/ggml/include
    DO_LINK=true
fi

# --- 6. LINK ---

# 1. Verify Libraries Exist (Don't fail silently!)
if [ ! -f "$LIB_LLAMA" ]; then echo "ERROR: Missing $LIB_LLAMA"; exit 1; fi
if [ ! -f "$LIB_GGML" ]; then echo "ERROR: Missing $LIB_GGML"; exit 1; fi

# Check for CPU lib, but allow fallback if you found it elsewhere
if [ ! -f "$LIB_GGML_CPU" ]; then
    echo "WARNING: $LIB_GGML_CPU not found."
    # Try to find it automatically if the hardcoded path is wrong
    DETECTED_CPU=$(find "$LLAMA_PATH/build" -name "libggml-cpu.a" | head -n 1)
    if [ ! -z "$DETECTED_CPU" ]; then
        echo "Found it at: $DETECTED_CPU"
        LIB_GGML_CPU="$DETECTED_CPU"
    else
        echo "ERROR: Could not find libggml-cpu.a anywhere. Linker will fail."
        exit 1
    fi
fi

if [ "$DO_LINK" = true ] || [ ! -f "mygame" ]; then
    echo "Linking..."

    # We use --start-group and --end-group to solve the circular dependency
    # between ggml, ggml-cpu, and ggml-base.
    g++ out/main.o native/GemmaWrapper.o \
        -o mygame \
        -Wl,--start-group \
        $LIB_LLAMA \
        $LIB_GGML \
        $LIB_GGML_CPU \
        $LIB_GGML_BASE \
        -Wl,--end-group \
        $HL_EXTS \
        $SYS_LIBS \
        -lhl -lpthread -lm -ldl -lstdc++ -fopenmp

    if [ $? -eq 0 ]; then
        echo "Build Complete! Run ./mygame"
    else
        echo "Linking Failed."
        exit 1
    fi
else
    echo "Build up to date."
fi
