#/bin/bash

#Program name "Begin Assembly"
#Author: F. Holliday
#This file is the script file that accompanies the "Begin Assembly" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -gdwarf -l isfloat.lis -o isfloat.o isfloat.asm

echo "Compile the source file driver.c"
gcc  -m64 -g -Wall -no-pie -o driver.o -std=c2x -c driver.c

echo "Link the object modules to create an executable file"
gcc -m64 -g -no-pie -o learn.out isfloat.o manager.o driver.o -std=c2x -Wall -z noexecstack

echo "Execute the program that new students use to understand assembly programming"
chmod +x learn.out
gdb ./learn.out

echo "This bash script will now terminate."



