#include <stdio.h>

// Function declaration with pointer and size parameters
void output_my_array(double* my_array, int my_array_size) {
    printf("Array my_array contents:\n");
    for (int i = 0; i < my_array_size; i++) {
        printf("%lf ", my_array[i]);
    }
    printf("\n");
}

/*int main() {
    // Example array
    int my_array[] = { 10, 20, 30, 40, 50 };
    int array_size = sizeof(my_array) / sizeof(my_array[0]);

    // Call the function
    output_my_array(my_array, array_size);

    return 0;
}*/
