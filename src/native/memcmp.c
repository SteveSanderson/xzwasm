int memcmp(const void *s1, const void *s2, unsigned long len)
{
    if (s1 == s2)
    {
        return 0;
    }

    const unsigned char *p = s1;
    const unsigned char *q = s2;

    while (len > 0)
    {
        if (*p != *q)
        {
            return (*p > *q) ? 1 : -1;
        }

        len--;
        p++;
        q++;
    }

    return 0;
}
