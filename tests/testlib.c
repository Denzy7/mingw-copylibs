#include "testlib.h"
#include <stdlib.h>
#include <time.h>
int testfunc()
{
    time_t t;
    time(&t);
    srand(t);
    return rand();
}
