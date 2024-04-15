#/bin/bash

#Program name "Variance"
#Author: S. Hicken
#This file is the script file that accompanies the "Variance" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file executive.asm"
nasm -f elf64 -l executive.lis -o executive.o executive.asm

echo "Assemble the source file fill_random_array.asm"
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

echo "Assemble the source file normalize_array.asm"
nasm -f elf64 -l normalize_array.lis -o normalize_array.o normalize_array.asm

echo "Assemble the source file is_nan.asm"
nasm -f elf64 -l is_nan.lis -o is_nan.o is_nan.asm

echo "Compile the source file main.c"
gcc -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Compile the source file show_array.c"
gcc -m64 -Wall -no-pie -o show_array.o -std=c2x -c show_array.c

echo "Compile the source file sort.c"
gcc -m64 -Wall -no-pie -o sort.o -std=c2x -c sort.c

#echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o norm.out sort.o main.o fill_random_array.o show_array.o is_nan.o normalize_array.o executive.o -Wall -z noexecstack -lm

echo "Execute the program to norm"
chmod +x norm.out
./norm.out

echo "This bash script will now terminate."
