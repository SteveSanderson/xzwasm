# xzwasm - XZ decompression for the browser

This is a browser-compatible NPM package that can decompress XZ streams. You can use this if you want your web server to return XZ-encoded content and have your JavaScript code see the uncompressed data. **It's an alternative to Gzip or Brotli compression for HTTP responses.**

Skip to: [Installation](#installation) or [How to use](#how-to-use)

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

 * If the best available alternative is Gzip
 * Or, if you're serving very large bundles of bytecode.
 * Or, if you care a lot about *compression* (not decompression) speed. XZ can be 5-10x faster to compress than Brotli, especially at the highest compression level.

**In most applications the added complexity of XZ via a custom decompressor library won't be worth the small bandwidth saving.** But it would be nice if browsers supported XZ natively. It's also a good demonstration of how a technology like WebAssembly can effectively extend the capabilities of a browser.

## Installation

### Option 1: As an NPM package

```
npm install --save xzwasm
```

You can then import things from `xzwasm` in your existing JavaScript/TypeScript files. Example:

```js
import { XzReadableStream } from 'xzwasm';
```

### Option 2: As a plain `<script>` tag

Download either [xzwasm.js](https://github.com/SteveSanderson/xzwasm/releases/latest/download/xzwasm.js) or [xzwasm.min.js](https://github.com/SteveSanderson/xzwasm/releases/latest/download/xzwasm.min.js) and place it in your project. Then add a `<script>` tag to load it:

```html
<script src="xzwasm.min.js"></script>
```

Your page will now have `xzwasm` in global scope. For example, you can call `new xzwasm.XzReadableStream(...)` - see below.

## How to use

First, [install xzwasm into your project](#installation).

Now, if you have an XZ-compressed stream, such as a `fetch` response body, you can get a decompressed response by wrapping it with `XzReadableStream`. Example:

```js
const compressedResponse = await fetch('somefile.xz');

const decompressedResponse = new Response(
   new XzReadableStream(compressedResponse.body)
);

// We now have a regular Response object, so can use standard APIs to parse its body data,
// such as .text(), .json(), or .arrayBuffer():
const text = await decompressedResponse.text();
```

The API is designed to be as JavaScript-standard as possible, so `XzReadableStream` is a [`ReadableStream`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream) instance, which in turn means you can feed it into a [`Response`](https://developer.mozilla.org/en-US/docs/Web/API/Response), and in turn get a blob, an ArrayBuffer, JSON data, or anything else that you browser can do with a `Response`.

**Note:** If you're using a `<script>` tag to reference xzwasm, you probably need to prefix `XzReadableStream` with `xzwasm`. For example, `new xzwasm.XzReadableStream(compressedResponse.body)`.

## Browser support

This should work on any moderately recent browser. It's tested on current versions of Firefox, Chrome, Edge, and Safari.

## Size and speed

The JavaScript/WebAssembly code in this library weighs just under **8 KB** if served with Brotli compression. So, of course, you only make a net gain on bandwidth if you're saving more than 8 KB by using XZ compression.

Decompressing `.xz` data using xzwasm, on Chromium, takes roughly 3x as long as Chromium's native Brotli decompressor.

As for whether this is a good tradeoff for you, see [Why would anyone do this?](#why-would-anyone-do-this)

## What about `.tar.xz` files?

Since the `.xz` format only represents one file, it's common for people to bundle up a collection of files as `.tar`, and then compress this to `.tar.xz`.

xzwasm doesn't have built-in support for `.tar`. However, you can use xzwasm to convert a `.tar.xz` stream to a stream representing the `.tar` file, and then pass this data to another library such as [js-untar](https://github.com/InvokIT/js-untar) or [tarballjs](https://github.com/ankitrohatgi/tarballjs) to get the bundled files.

## Building code in this repo

**Note:** This is only needed if you want to work on xzwasm itself. It's not required [if you just want to use xzwasm](#installation).

 * Clone this repo
 * Clone/update submodules
    * `git submodule update --init --recursive`
 * Ensure you have a working Clang toolchain that can build wasm
    * For example, install https://github.com/WebAssembly/wasi-sdk
    * `export wasisdkroot=/path/to/wask-sdk`
 * (For testing only) Ensure you have `xz` and `brotli` available as commands on $PATH
 * Run `make`

### Building the NPM package contents

 * Have `node` installed
 * `npm install`
 * Run `make package`

### Running scenario/perf tests

 * Have `node` installed
 * `npm install -g http-server`
 * `make run-sample`
