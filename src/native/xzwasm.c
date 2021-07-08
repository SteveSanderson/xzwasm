#include <stdlib.h>
#include <stdint.h>

#define BUFSIZE 512

typedef struct DecompressionContext {
    uint8_t in[BUFSIZE];
    uint8_t out[BUFSIZE];
} DecompressionContext;

DecompressionContext* create_context() {
    DecompressionContext* context = malloc(sizeof(DecompressionContext));
    return context;
}

void destroy_context(DecompressionContext* context) {
    free(context);
}
