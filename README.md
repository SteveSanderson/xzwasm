## Building

 * Clone/update submodules
    * `git submodule update --init --recursive`
 * Ensure you have a working Clang toolchain that can build wasm
    * For example, install https://github.com/WebAssembly/wasi-sdk
    * `export wasisdkroot=/path/to/wask-sdk`
 * Run `make`
