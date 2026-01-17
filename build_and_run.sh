#!/bin/bash

# 1. Build the C++ AI Extension (Only runs if files changed)
if ! make; then
    echo "Error building C++ extension."
    exit 1
fi

# 2. Build the Game (Haxe)
# We compile to HashLink Bytecode (.hl) which is WAY faster to build/debug
# than compiling to C code every time.
echo "Building Haxe..."
haxe debug.hxml

# 3. Run
# We need to tell HashLink where to find our new gemma.hdll if it's in the root
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./bin
hl bin/game.hl
