#include <stdio.h>
#include <math.h>

// should be const char*
extern double executive();

int main(void)
{
    printf("Welcome to Random Products, LLC.\n");
    printf("This software is maintained by Steven Hicken.\n");
    double name = executive();
    printf("Oh, %lf. We hope you enjoyed your arrays. Do come again.\n", name);
    printf("A zero will be returned to the operating system.\n");
    return 0;
}