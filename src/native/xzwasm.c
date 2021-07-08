#include <stdlib.h>
#include <emscripten.h>

EMSCRIPTEN_KEEPALIVE
char* testInt() {
    char *s1 = (char*) malloc(256*1024);
    s1[0] = 123;
    return s1;
}
