#include <stdlib.h>
#include <stdint.h>
#include "../../module/xz-embedded/linux/include/linux/xz.h"

#define BUFSIZE 65536

typedef struct DecompressionContextStruct {
    size_t bufsize;
    struct xz_buf b;
    struct xz_dec* s;
    uint8_t in[BUFSIZE];
    uint8_t out[BUFSIZE];
} DecompressionContext;
