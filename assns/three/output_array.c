#include <stdio.h>

// Function declaration with pointer and size parameters
void output_my_array(double* my_array, int my_array_size) {
    printf("Array my_array contents:\n");
    for (int i = 0; i < my_array_size; i++) {
        printf("%lf ", my_array[i]);
    }
    printf("\n");
}