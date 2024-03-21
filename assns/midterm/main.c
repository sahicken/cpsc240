#include <stdio.h>
#include <math.h>

extern double manager();

int main(void)
{
    printf("Welcome to Harmonic Arrays brought to you by Steven Hicken.\n");
    double var = manager();
    printf("Main received this number %lf and will think about it.\n", var);
    printf("MHave a good day. A zero will be returned to the operating system\n");
    return 0;
}