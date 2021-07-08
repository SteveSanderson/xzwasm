#include "xzwasm.h"

DecompressionContext* init() {
    DecompressionContext* context = (void*)123; //malloc(sizeof(DecompressionContext));
    return context;
}
