#include "xzwasm.h"

DecompressionContext* create_context() {
    DecompressionContext* context = malloc(sizeof(DecompressionContext));
    context->b.in = context->in;
    context->b.out = context->out;
    context->s = xz_dec_init(XZ_DYNALLOC, 1 << 26);
    return context;
}

void destroy_context(DecompressionContext* context) {
    free(context->s);
    free(context);
}
