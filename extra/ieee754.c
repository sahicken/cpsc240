#include <stdio.h>
#include <string.h> // For memcpy

void printDoubleAsHex(double myDouble) {
    unsigned long long intBits;
    memcpy(&intBits, &myDouble, sizeof(intBits));

    printf("Double in hexadecimal: %llx\n", intBits);
}

int main(void) {
    double myDouble = 23.7; // Replace with your desired value
    printDoubleAsHex(myDouble);
    return 0;
}

