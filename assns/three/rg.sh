#/bin/bash

#Program name "Variance"
#Author: S. Hicken
#This file is the script file that accompanies the "Variance" program.
#Prepare for execution in gdb (debug) mode.

#Delete some un-needed files
rm *.o
rm *.out

# Assemble (debug): nasm -f elf64 -gdwarf -l file.lis -o file.o file.asm

echo "Assemble the source file manager.asm"
nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -gdwarf -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file input_array.asm"
nasm -f elf64 -gdwarf -l input_array.lis -o input_array.o input_array.asm

echo "Assemble the source file compute_mean.asm"
nasm -f elf64 -gdwarf -l compute_mean.lis -o compute_mean.o compute_mean.asm

echo "Compile the source file driver.c"
gcc -g -m64 -Wall -no-pie -o driver.o -std=c2x -c driver.c

echo "Compile the source file output_array.c"
gcc -g -m64 -Wall -no-pie -o output_array.o -std=c2x -c output_array.c

echo "Compile the source file compute_variance.c"
g++ -g -m64 -Wall -fno-pie -no-pie -o compute_variance.o -std=c++11 -c compute_variance.cpp

#echo "Link the object modules to create an executable file"
g++ -g -m64 -no-pie -o variance.out isfloat.o driver.o input_array.o output_array.o compute_mean.o compute_variance.o manager.o -Wall -z noexecstack -lm

echo "Execute the program to calculate variance (debug)"
chmod +x variance.out
gdb ./variance.out -tui

echo "This bash script will now terminate."