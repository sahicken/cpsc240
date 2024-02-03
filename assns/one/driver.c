//****************************************************************************************************************************
// Program name: "Average Driving Time".  This program calculates the average driving time of a driver moving around NOC.     *
//                                                                                                                            *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
// but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
// the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
// <https://www.gnu.org/licenses/>.                                                                                           *
//****************************************************************************************************************************

// Author: Steven Hicken
// Author email: sahicken@csu.fullerton.edu
// Program name: Average Driving Time
// Programming languages: One module in C, one in X86, and one in bash.
// Date program began: 2024-Jan-23
// Date of last update: 2024-Jan-2x
// Files in this program: driver.c, average.asm, r.sh.  At a future date rg.sh may be added
// Testing: indev (pre-alpha)
// Status: won't compile

// Purpose of this program:
//   This program is a starting point for those learning to program in x86 assembly.

// This file
//   File name: driver.c
//   Language: C language, 202x standardization where x will be a decimal digit.
//   Max page width: 124 columns
//   Compile: gcc -m64 -no-pie -o driver.o -std=c20 -Wall driver.c -c
//   Link: gcc -m64 -no-pie -o learn.out average.o driver.o -std=c20 -Wall -z noexecstack

#include <stdio.h>
// #include <string.h>
// #include <stdlib.h>

extern double average();

int main(int argc, const char *argv[])
{
    printf("Welcome to Average Driving Time maintained by Steven Hicken\n");
    double avg = 0.0;
    avg = average();
    printf("The driver has received this number %f and will keep it for future use. Have a great day.\n", avg);
    printf("A zero will be sent to the operating system as a signal of a successful execution.\n");
}
