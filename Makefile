xzdir := module/xz-embedded
xzlibdir := $(xzdir)/linux/lib/xz

ifeq ($(wasisdkroot),)
  $(error wasisdkroot is not set)
endif

.PHONY: all clean sample run-sample

all: dist/xzwasm.wasm sample/lib/*.* sample/data/random*

dist/xzwasm.wasm: src/native/* $(xzdir)/**/*
	mkdir -p dist
	$(wasisdkroot)/bin/clang --sysroot=$(wasisdkroot)/share/wasi-sysroot \
		--target=wasm32 -DNDEBUG -Os -s -nostdlib -mbulk-memory -Wl,--no-entry \
		-DXZ_DEC_CONCATENATED \
		-Wl,--export=create_context \
		-Wl,--export=destroy_context \
		-Wl,--export=supply_input \
		-Wl,--export=get_next_output \
		-o dist/xzwasm.wasm \
		-I$(xzdir)/userspace/ \
		-I$(xzdir)/linux/include/linux/ \
		module/walloc/walloc.c \
		src/native/*.c \
		$(xzlibdir)/xz_crc32.c \
		$(xzlibdir)/xz_dec_stream.c \
		$(xzlibdir)/xz_dec_lzma2.c

sample/lib/*.*: dist/xzwasm.wasm src/xzwasm.js
	mkdir -p sample/lib
	cp dist/xzwasm.wasm sample/lib
	cp src/xzwasm.js sample/lib

sample/data/random*:
	# Make some random data for perf test. Obviously it won't compress well but that's not important here.
	dd if=/dev/urandom of=sample/data/random.bin bs=1M count=10 iflag=fullblock
	xz --check=crc32 -9 -k sample/data/random.bin
	brotli sample/data/random.bin -o sample/data/random-brotli.bin.br

run-sample:
	http-server -b

clean:
	rm -rf dist
	rm -rf sample/lib
	rm sample/data/random*
