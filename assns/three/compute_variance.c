#include <stdio.h>
#include <math.h>

// Function to calculate the variance of an array of numbers
double calculate_variance(double arr[], int n) {
    double mean = 0.0, variance = 0.0;

    // Calculate the mean
    for (int i = 0; i < n; ++i) {
        mean += arr[i];
    }
    mean /= n;

    // Calculate the variance
    for (int i = 0; i < n; ++i) {
        variance += pow(arr[i] - mean, 2);
    }
    variance /= n;

    return variance;
}

/*int main() {
    // Example usage
    double numbers[] = {2.5, 3.7, 1.8, 4.1, 5.0};
    int num_elements = sizeof(numbers) / sizeof(numbers[0]);

    double result = calculate_variance(numbers, num_elements);
    printf("Variance: %.2f\n", result);

    return 0;
}*/
