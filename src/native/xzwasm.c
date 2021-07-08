#include "xzwasm.h"

DecompressionContext* create_context() {
    DecompressionContext* context = malloc(sizeof(DecompressionContext));
    return context;
}

void destroy_context(DecompressionContext* context) {
    free(context);
}
