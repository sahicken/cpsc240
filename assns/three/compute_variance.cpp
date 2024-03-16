#include <cmath>

extern "C" double compute_variance(double arr[], int size, double mean) {
    double variance = 0.0;
    for (int i = 0; i < size; i++) {
        variance += std::pow(arr[i] - mean, 2);
    }
    return variance / size;
}