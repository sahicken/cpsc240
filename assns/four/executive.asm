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
;  Testing: done
;  Status: working
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
global executive

extern fgets
extern scanf
extern stdin
extern strlen
extern printf
extern fill_random_array
extern normalize_array
extern show_array

easy_str_sz equ 50 ; strings < 50 bytes
arr_sz equ 100 ; support 100 numbers max

segment .data
;This section (or segment) is for declaring initialized arrays
prompt_name db "Please enter your name: ",0
prompt_title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ",0
msg_greeting db "Nice to meet you %s %s",10,0

msg_arr_gen db "This program will generate 64-bit IEEE float numbers",10,0
prompt_arr_sz db "How many numbers do you want? Today’s limit is 100 per customer: ",0
msg_arr_show db "Your numbers have been stored in an array. Here is that array.",10,0

msg_arr_norm db "The array will now be normalized to the range 1.0 to 2.0  Here is the normalized array",10,0
msg_arr_sort db "The array will now be sorted",10,0
msg_goodbye db "Good bye %s. You are welcome any time.",10,0

fmt_int db "%d",0

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

array resq arr_sz

name resb easy_str_sz
title resb easy_str_sz

segment .text


executive:

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


;BEGIN NAME I/O
; output prompt for name
mov rax, 0
mov rdi, prompt_name
call printf

; input name
mov rax, 0
mov rdi, name
mov rsi, easy_str_sz
mov rdx, [stdin]
call fgets

; remove newline from name
mov rax, 0
mov rdi, name
call strlen
mov [name+rax-1], byte 0
;END NAME I/O



;BEGIN TITLE I/O
; output prompt for tile
mov rax, 0
mov rdi, prompt_title
call printf

; input title
mov rax, 0
mov rdi, title
mov rsi, easy_str_sz
mov rdx, [stdin]
call fgets

; remove newline (title)
mov rax, 0
mov rdi, title
call strlen
mov [title+rax-1], byte 0
;END TITLE I/O


; GREETING BEGIN
mov rax, 0
mov rdi, msg_greeting
mov rsi, title
mov rdx, name
call printf
; GREETING END

;msg_arr_gen db "This program will generate 64-bit IEEE float numbers",10,0
;prompt_arr_sz db "How many numbers do you want? Today’s limit is 100 per customer: ",0
;msg_arr_show db "Your numbers have been stored in an array. Here is that array.",10,0

; announce to the user the array generation
mov rax, 0
mov rdi, msg_arr_gen
call printf

; print a nice looking prompt
mov rax, 0
mov rdi, prompt_arr_sz
call printf

; input the size (request)
mov rax, 0
mov rdi, fmt_int
mov rsi, rsp
call scanf
mov r15, [rsp]

; ensure it's not too big (over 100)
cmp r15, arr_sz
jg too_big
jmp ok
too_big:
mov r15, arr_sz
ok:
; not too big now, yay!

; setup fill array fxn call
mov rax, 0
; move the pointer into 1st arg
mov rdi, array
; 2nd arg is max size of array
mov rsi, r15
call fill_random_array

; inform use of successful fill
mov rax, 0
mov rdi, msg_arr_show
call printf

mov rax, 0
mov rdi, array
mov rsi, r15
call show_array

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
