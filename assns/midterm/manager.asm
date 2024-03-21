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

global manager

extern printf
extern input_array
extern harmonic
extern output_array

arr_sz equ 12

segment .data
;This section (or segment) is for declaring initialized arrays

msg_arr_tx_aofb db "This program will fulfill all your harmonic needs",10,0
msg_arr_tx_bofb db "Enter a sequence of 64-bit floats separated by white space.",10,0
prompt_arr_tx db "After the last input press enter followed by Control+D: ",0

msg_arr_rx db "These numbers are in the array",0
msg_arr_var db "The harmonic sum has been calculated to be %lf",10,0

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

array resq arr_sz

segment .text

manager:

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



;BEGIN MANAGER I/O
; output prompt for name
mov rax, 0
mov rdi, msg_arr_tx_aofb
call printf

mov rax, 0
mov rdi, msg_arr_tx_bofb
call printf

mov rax, 0
mov rdi, prompt_arr_tx
call printf
;END MANAGER I/O

; input the array of floats
mov rax, 0
; move the pointer into 1st arg
mov rdi, array
; 2nd arg is max size of array
mov rsi, arr_sz
call input_array
; now store *true* size of array
mov r15, rax

;BEGIN MANAGER I/O
; acknowledge array received
mov rax, 0
mov rdi, msg_arr_rx
call printf
;END MANAGER I/O

mov rax, 0
mov rdi, array
mov rsi, r15
call output_array

; compute the mean
mov rax, 0
mov rdi, array
mov rsi, r15
call harmonic
; store mean for later use
movsd xmm14, xmm0

;BEGIN MANAGER I/O
; output the variance of the array
mov rax, 1
mov rdi, msg_arr_var
movsd xmm0, xmm14
call printf
;END MANAGER I/O

;BEGIN .TEXT POSTREQS
;Send back the variance of the array
push qword 0
push qword 0
movsd [rsp], xmm14

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
