#include <stdint.h>
#include <stdbool.h>

// We have to polyfill this because, even with WebAssembly bulk memory extensions,
// there's no built-in memcmp.
int memcmp(const void *s1, const void *s2, unsigned long len)
{
    if (s1 == s2) {
        return 0;
    }

    const unsigned char *p = s1;
    const unsigned char *q = s2;

    while (len > 0) {
        if (*p != *q) {
            return (*p > *q) ? 1 : -1;
        }

        len--;
        p++;
        q++;
    }

    return 0;
}

// ------------------------------------------------------------------------------------------------
//
// The remainder would be provided by WebAssembly bulk memory extensions (if compiling with -mbulk-memory),
// but that's not yet supported by Safari, so provide our own. Note that Safari Technology Preview
// does support bulk memory, so these will be redundant soon.

void* memmove(void *dest, const void *src, size_t size)
{
	uint8_t *d = dest;
	const uint8_t *s = src;
	size_t i;

	if (d < s) {
		for (i = 0; i < size; ++i)
			d[i] = s[i];
	} else if (d > s) {
		i = size;
		while (i-- > 0)
			d[i] = s[i];
	}

	return dest;
}

void* memset(void *s, int c, size_t len) {
    unsigned char *dst = s;

    while (len > 0) {
        *dst = (unsigned char) c;
        dst++;
        len--;
    }

    return s;
}

// From https://stackoverflow.com/questions/17591624
void* memcpy(void *dst, const void *src, size_t len)
{
    size_t i;

    // If everything is aligned on long boundaries, we can copy
    // in units of long instead of char.
    if ((uintptr_t)dst % sizeof(long) == 0
        && (uintptr_t)src % sizeof(long) == 0
        && len % sizeof(long) == 0) {

        long *d = dst;
        const long *s = src;

        for (i = 0; i < len/sizeof(long); i++)
            d[i] = s[i];
    }
    else {
        char *d = dst;
        const char *s = src;

        for (i = 0; i < len; i++)
            d[i] = s[i];
    }

    return dst;
}
