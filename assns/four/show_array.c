#include <stdio.h>

void show_array(double array_of_floats[], int size) {
    for (int i = 0; i < size; ++i) {
        printf("Element %d: %.2f\n", i, array_of_floats[i]);
    }
}