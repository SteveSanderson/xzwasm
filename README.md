# xzwasm - XZ decompression for the browser

This is a browser-compatible NPM package that can decompress XZ streams. You can use this if you want your web server to return XZ-encoded content and have your JavaScript code see the uncompressed data. **It's an alternative to Gzip or Brotli compression for HTTP responses.**

Skip to: [How to use](#how-to-use)

## Why would anyone do this?

Although Brotli is an excellent general-purpose compression algorithm, there are some kinds of data for which XZ gives better compression ratios.

 * Brotli is based around a large dictionary of web-related text snippets, and usually outperforms XZ for text-based content (e.g., HTML, JS, CSS, WOFF, etc.).
 * XZ (or rather, the underlying LZMA2 algorithm) is not so oriented around text content and - in my experiments - usually compresses bitcode (e.g., WebAssembly `.wasm` files, .NET `.dll` files) better than Brotli

Example, in each case using the highest available compression level:

| Scenario | Uncompressed | Gzip | Brotli | XZ |
| -------- | ------------ | ---- | ------ | -- |
| `.wasm` file | 2220KB | 894KB | 763KB | 744KB |
| `.dll` file bundle | 3058KB | 1159KB | 988KB | 963KB |

The main drawbacks to using XZ in the browser are:

 * You have to bundle your own decompressor. Using this `xzwasm` library adds slightly under 8KB to your site (assuming it's served minified and Brotli-compressed).
 * Decompressing XZ content takes more CPU time than decompressing Brotli. In part that's because of the overhead of WebAssembly vs pure native code, but in part is inherent to the algorithms. As an estimate, the `.wasm` file from above takes my browser 21ms to decompress if served as Brotli, or 69ms if served as XZ and decompressed with `xzwasm`.

So, you would only benefit from using XZ:

 * If the best available alternative is Gzip (as is currently the case in Firefox)
 * Or, if you're serving very large bundles of bytecode.
 * Or, if you care a lot about *compression* (not decompression) speed. XZ can be 5-10x faster to compress than Brotli, especially at the highest compression level.

In most applications the added complexity of XZ via a custom decompressor library won't be worth the small bandwidth saving. But it would be nice if browsers supported XZ natively. It's also a good demonstration of how a technology like WebAssembly can effectively extend the capabilities of a browser.

## How to use

TODO: Add instructions

## Building

 * Clone/update submodules
    * `git submodule update --init --recursive`
 * Ensure you have a working Clang toolchain that can build wasm
    * For example, install https://github.com/WebAssembly/wasi-sdk
    * `export wasisdkroot=/path/to/wask-sdk`
 * (For testing only) Ensure you have `xz` and `brotli` available as commands on $PATH
 * Run `make`

To build the NPM package contents:

 * Have `node` installed
 * `npm install`
 * Run `make package`

## Running scenario/perf tests

 * Have `node` installed
 * `npm install -g http-server`
 * `make run-sample`
