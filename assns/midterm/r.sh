#/bin/bash

#Program name "Variance"
#Author: S. Hicken
#This file is the script file that accompanies the "Variance" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Assemble the source file harmonic.asm"
nasm -f elf64 -l harmonic.lis -o harmonic.o harmonic.asm

echo "Compile the source file main.c"
gcc -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Compile the source file output_array.c"
gcc -m64 -Wall -no-pie -o output_array.o -std=c2x -c output_array.c

#echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o h.out isfloat.o main.o input_array.o output_array.o harmonic.o manager.o -Wall -z noexecstack -lm

echo "Execute the program to calculate harmonic sum"
chmod +x h.out
./h.out

echo "This bash script will now terminate."
