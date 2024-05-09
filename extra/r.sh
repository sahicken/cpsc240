#/bin/bash

echo "Assemble the source file is_nan.asm"
nasm -f elf64 -l is_nan.lis -o is_nan.o is_nan.asm

echo "Compile the source file rdrand.c"
g++ -m64 -Wall -no-pie -o rdrand.o -std=c++11 -c rdrand.cpp

echo "Compile the source file ieee754.c"
gcc -m64 -Wall -no-pie -o ieee754.o -std=c99 -c ieee754.c

echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o rand.out rdrand.o ieee754.o is_nan.o -Wall -z noexecstack -lm
