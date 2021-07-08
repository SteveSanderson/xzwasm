## Building

 * Clone/update submodules
    * `git submodule update --init --recursive`
 * Ensure you have a working Clang toolchain that can build wasm
    * For example, install https://github.com/WebAssembly/wasi-sdk
    * `export wasisdkroot=/path/to/wask-sdk`
 * (For testing only) Ensure you have `xz` and `brotli` available as commands on $PATH
 * Run `make`
