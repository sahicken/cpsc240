#include <stdio.h>
#include <math.h>

extern double manager();

int main(void)
{
    printf("Welcome to Arrays of floating point numbers.\n");
    printf("Brought to you by Steven Hicken.\n");
    double variance = manager();
    printf("Main received this number %lf and will keep it for future use.\n", variance);
    printf("Main will return 0 to the operating system. Bye.\n");
    return 0;
}