#/bin/bash

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file multiplier.asm"
nasm -f elf64 -gdwarf -l multiplier.lis -o multiplier.o multiplier.asm

echo "Assemble the source file sin.asm"
nasm -f elf64 -gdwarf -l sin.lis -o sin.o sin.asm

echo "Assemble the source file strlen.asm"
nasm -f elf64 -gdwarf -l strlen.lis -o strlen.o strlen.asm

echo "Assemble the source file producer.asm"
nasm -f elf64 -gdwarf -l producer.lis -o producer.o producer.asm

echo "Assemble the source file fgets.asm"
nasm -f elf64 -gdwarf  -l fgets.lis -o fgets.o fgets.asm

echo "Assemble the source file fputs.asm"
nasm -f elf64 -gdwarf -l fputs.lis -o fputs.o fputs.asm

echo "Compile the source file main.c"
gcc -m64 -Wall -no-pie -o main.o -std=c2x -c main.c -g

echo "Compile the source file ftoa.c"
gcc -m64 -Wall -no-pie -o ftoa.o -std=c2x -c ftoa.c -g

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o sin.out fputs.o fgets.o ftoa.o producer.o strlen.o sin.o multiplier.o main.o -Wall -z noexecstack -lm -g

echo "Execute the program to sin DEBUG"
chmod +x sin.out
gdb ./sin.out -tui

echo "This bash script will now terminate."
