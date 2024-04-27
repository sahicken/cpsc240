#/bin/bash

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file atof.asm"
nasm -f elf64 -l atof.lis -o atof.o atof.asm

echo "Assemble the source file ftoa.asm"
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm

echo "Assemble the source file multiplier.asm"
nasm -f elf64 -l multiplier.lis -o multiplier.o multiplier.asm

echo "Assemble the source file sin.asm"
nasm -f elf64 -l sin.lis -o sin.o sin.asm

echo "Assemble the source file strlen.asm"
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm

echo "Assemble the source file producer.asm"
nasm -f elf64 -l producer.lis -o producer.o producer.asm

echo "Assemble the source file director.asm"
nasm -f elf64 -l director.lis -o director.o director.asm

echo "Assemble the source file fgets.asm"
nasm -f elf64 -l fgets.lis -o fgets.o fgets.asm

echo "Assemble the source file fputs.asm"
nasm -f elf64 -l fputs.lis -o fputs.o fputs.asm

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o sin.out fputs.o fgets.o director.o producer.o strlen.o sin.o multiplier.o ftoa.o atof.o -Wall -z noexecstack -lm

echo "Execute the program to sin"
chmod +x sin.out
./sin.out

echo "This bash script will now terminate."
