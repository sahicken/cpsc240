#/bin/bash

#Program name "Compute Triangle"
#Authors: F. Holliday, S. Hicken
#This file is the script file that accompanies the "Compute" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Compile the source file driver.c"
gcc  -m64 -Wall -no-pie -o driver.o -std=c2x -c driver.c

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o triangle.out isfloat.o manager.o driver.o -std=c2x -Wall -z noexecstack -lm

echo "Execute the program to calculate triangles"
chmod +x triangle.out
./triangle.out

echo "This bash script will now terminate."
