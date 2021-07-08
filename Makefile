xzdir := module/xz-embedded
xzlibdir := $(xzdir)/linux/lib/xz

.PHONY: all clean sample

all: dist/xzwasm.wasm sample

dist/xzwasm.wasm: src/native/xzwasm.c $(xzdir)/**/*
	mkdir -p dist
	emcc -Os -s --no-entry -o dist/xzwasm.wasm \
		-I$(xzdir)/userspace/ \
		-I$(xzdir)/linux/include/linux/ \
		src/native/xzwasm.c \
		$(xzlibdir)/xz_crc32.c \
		$(xzlibdir)/xz_dec_stream.c \
		$(xzlibdir)/xz_dec_lzma2.c

sample:
	cp dist/xzwasm.wasm sample/

clean:
	rm -rf dist/
