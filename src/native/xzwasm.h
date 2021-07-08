#include <stdlib.h>
#include <stdint.h>

#define BUFSIZE 512

typedef struct DecompressionContext {
    uint8_t in[BUFSIZE];
    uint8_t out[BUFSIZE];
} DecompressionContext;
