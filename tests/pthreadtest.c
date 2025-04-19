#include <pthread.h>
#include <stdio.h>
#include "testlib.h"

void* thr(void* arg)
{
    printf("pthreadtest %d\n", testfunc());
    return NULL;
}

int main()
{
    pthread_t t;

    if(pthread_create(&t, NULL, thr, NULL) != 0)
    {
        perror("pthread_create");
        return 1;
    }

    pthread_join(t, NULL);
}
