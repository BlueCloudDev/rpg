!#/bin/bash
# This is needed because llama needs to be built for dynamic linking for .hdll
cd ../llama.cpp
rm -rf build
cmake -B build -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build build --config Release -j $(nproc)
cmake --build build --config Release --target llama ggml
