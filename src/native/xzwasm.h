#include <stdlib.h>
#include <stdint.h>
#include "../../module/xz-embedded/linux/include/linux/xz.h"

#define BUFSIZE 512

typedef struct DecompressionContextStruct {
    uint8_t in[BUFSIZE];
    uint8_t out[BUFSIZE];
    struct xz_buf b;
    struct xz_dec* s;
} DecompressionContext;
