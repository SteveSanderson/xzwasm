xzdir := module/xz-embedded
xzlibdir := $(xzdir)/linux/lib/xz

ifeq ($(wasisdkroot),)
  $(error wasisdkroot is not set)
endif

.PHONY: all clean sample

all: dist/xzwasm.wasm sample/lib/*.*

dist/xzwasm.wasm: src/native/* $(xzdir)/**/*
	mkdir -p dist
	$(wasisdkroot)/bin/clang --sysroot=$(wasisdkroot)/share/wasi-sysroot \
		--target=wasm32 -DNDEBUG -Os -s -nostdlib -mbulk-memory -Wl,--no-entry \
		-Wl,--export=create_context \
		-Wl,--export=destroy_context \
		-o dist/xzwasm.wasm \
		-I$(xzdir)/userspace/ \
		-I$(xzdir)/linux/include/linux/ \
		module/walloc/walloc.c \
		src/native/xzwasm.c \
		$(xzlibdir)/xz_crc32.c \
		$(xzlibdir)/xz_dec_stream.c \
		$(xzlibdir)/xz_dec_lzma2.c

sample/lib/*.*: dist/xzwasm.wasm
	mkdir -p sample/lib
	cp dist/xzwasm.wasm sample/lib

clean:
	rm -rf dist
	rm -rf sample/lib
