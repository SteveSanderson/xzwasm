xzdir := module/xz-embedded
xzlibdir := $(xzdir)/linux/lib/xz

ifeq ($(wasisdkroot),)
  $(error wasisdkroot is not set)
endif

ifeq ($(shell grep -o WSL2 /proc/version ),WSL2)
	# Runs a lot faster for me
	webpackcommand := cmd.exe /c npm run webpack
else
	webpackcommand := npm run webpack
endif

.PHONY: all clean sample run-sample package

all: dist/native/xzwasm.wasm sample/lib/*.* sample/data/random*

package: dist/package/xzwasm.js

dist/native/xzwasm.wasm: src/native/* $(xzdir)/**/* Makefile
	mkdir -p dist/native
	$(wasisdkroot)/bin/clang --sysroot=$(wasisdkroot)/share/wasi-sysroot \
		--target=wasm32 -DNDEBUG -Os -s -nostdlib -Wl,--no-entry \
		-DXZ_DEC_CONCATENATED -DXZ_USE_CRC64 \
		-Wl,--export=create_context \
		-Wl,--export=destroy_context \
		-Wl,--export=supply_input \
		-Wl,--export=get_next_output \
		-o dist/native/xzwasm.wasm \
		-I$(xzdir)/userspace/ \
		-I$(xzdir)/linux/include/linux/ \
		module/walloc/walloc.c \
		src/native/*.c \
		$(xzlibdir)/xz_crc32.c \
		$(xzlibdir)/xz_crc64.c \
		$(xzlibdir)/xz_dec_stream.c \
		$(xzlibdir)/xz_dec_lzma2.c

dist/package/xzwasm.js: webpack.config.js src/*.* dist/native/xzwasm.wasm package.json
	@$(webpackcommand)

sample/lib/*.*: dist/package/xzwasm.js
	mkdir -p sample/lib
	cp dist/package/xzwasm.js sample/lib

sample/data/random*:
	# Random data isn't very realistic. The sample wasm file compresses in a more relevant way.
	dd if=/dev/urandom of=sample/data/random-10K.bin bs=1K count=10 iflag=fullblock
	dd if=/dev/urandom of=sample/data/random-1M.bin bs=1M count=1 iflag=fullblock
	dd if=/dev/urandom of=sample/data/random-10M.bin bs=1M count=10 iflag=fullblock
	xz --check=crc64 -9 -k sample/data/random-10K.bin
	xz --check=crc32 -9 -k sample/data/random-1M.bin
	xz --check=crc32 -9 -k sample/data/random-10M.bin
	xz --check=crc32 -9 -k sample/data/sample.wasm
	brotli sample/data/random-10K.bin -o sample/data/random-10K.bin-brotli.br
	brotli sample/data/random-1M.bin -o sample/data/random-1M.bin-brotli.br
	brotli sample/data/random-10M.bin -o sample/data/random-10M.bin-brotli.br
	brotli sample/data/sample.wasm -o sample/data/sample.wasm-brotli.br

run-sample:
	http-server sample/ -b

clean:
	rm -rf dist
	rm -rf sample/lib
	rm sample/data/random*
	rm sample/data/sample.wasm.xz
	rm sample/data/sample.wasm-brotli.br
