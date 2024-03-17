;****************************************************************************************************************************
; Program name: "Variance".  This program calculates the variance of a list of doubles.     *
;                                                                                                                            *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
; but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
; the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
; <https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Steven Hicken
;  Author email: sahicken@csu.fullerton.edu
;
;Program information
;  Program name: Variance
;  Programming languages: 3 modules in C, 3 in X86, 1 in C++, and 2 in bash.
;  Date program began: 2024-Mar-1
;  Date of last update: 2024-Mar-17
;  Files in this program: driver.c, manager.asm, isfloat.asm, compute_variance.cpp, r.sh, rg.sh, input_array.asm, output_array.c, compute_mean.asm
;  Testing: compiles
;  Status: broken
;
;Purpose
;  This program inputs arrays (double precision) and calculates variance
;
;This file:
;  File name: file.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l file.lis -o file.o file.asm
;  Assemble (debug): nasm -f elf64 -gdwarf -l file.lis -o file.o file.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double file();
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;========= Begin source code ====================================================================================
;Declaration area

global compute_mean

segment .data
;This section (or segment) is for declaring initialized arrays

zero dq 0.0

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

segment .text

compute_mean:

;BEGIN .TEXT PREREQS
; backup GPRs (General Purpose Registers)
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

; backup all other registers (meaning not GPRs)
mov rax,7
mov rdx,0
xsave [backup_storage_area]
;END .TEXT PREREQS


; will use loop instruction and rcx
mov r15, rdi         ; pointer to front of array
mov r14, rsi         ; size of array (# elements)
movsd xmm15, [zero]  ; sum begins at zero

; init rcx to the size of array
mov rcx, r14
sub rcx, 1
; add together all the values in array
summation:

; add each index (descending order)
addsd xmm15, [r15 + 8 * rcx]
loop summation

; divide to get avg
movq xmm14, r14
divsd xmm15, xmm14

;BEGIN .TEXT POSTREQS
;Send back length of "third" side
push qword 0
push qword 0
movsd [rsp], xmm15

;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

movsd xmm0, [rsp]
pop rax
pop rax

;Restore the GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp   ;Restore rbp to the base of the activation record of the caller program
ret
;END .TEXT POSTREQS (BROKEN)
