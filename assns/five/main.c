#include <stdio.h>

extern double producer();

int main(void) {
    printf("Welcome to Marvelous Marvin’s Area Machine.\nWe compute all your areas.\n");
    double number = producer();
    printf("The driver received this number %lf and will keep it.\n", number);
    printf("A zero will be sent to the OS as a sign of successful conclusion.\nBye.\n");

    return 0;
}