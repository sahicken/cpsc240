;****************************************************************************************************************************
; Program name: "Average Driving Time".  This program calculates the average driving time of a driver moving around NOC.     *
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
;  Program name: Average Driving Time
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2024-Jan-23
;  Date of last update: 2024-Apr-2x
;  Files in this program: driver.c, average.asm, r.sh.  At a future date rg.sh may be added.
;  Testing: indev (pre-alpha)
;  Status: won't compile
;
;Purpose
;  This program is a starting point for those learning to program in x86 assembly.
;
;This file:
;  File name: average.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -l average.lis -o average.o average.asm
;  Assemble (debug): nasm -g dwarf -l average.lis -o average.o average.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: float average();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section, everything here does not have its own place of declaration

extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global manager

easy_str_sz equ 50 ; simple strings < 50 bytes

segment .data
;This section (or segment) is for declaring initialized arrays

prompt_for_name db "Please enter your first and last names: ",0
prompt_for_title db "Please enter your title such as Lieutenant, Chief, Mr, Ms, Influencer, Chairman, Freshman, Foreman, Project Leader, etc: ",0
thanks db "Thank you %s %s",10,0

fmt_dbl db "%lf",0

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

user_name resb easy_str_sz
user_title resb easy_str_sz

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

;BEGIN USER NAME I/O
;Output prompt for the user (name)
mov rax, 0
mov rdi, prompt_for_name
call printf

;Input user's name
mov rax, 0
mov rdi, user_name
mov rsi, easy_str_sz
mov rdx, [stdin]
call fgets

;Remove newline from name
mov rax, 0
mov rdi, user_name
call strlen
mov [user_name+rax-1], byte 0
;END USER NAME I/O

;BEGIN USER TITLE I/O
;Output prompt for the user (title)
mov rax, 0
mov rdi, prompt_for_title
call printf

;Input user's title
mov rax, 0
mov rdi, user_title
mov rsi, easy_str_sz
mov rdx, [stdin]
call fgets

;Remove newline from title
mov rax, 0
mov rdi, user_title
call strlen
mov [user_name+rax-1], byte 0
;END USER TITLE I/O

;thank the user
mov rax, 0
mov rdi, thanks
mov rsi, user_name
mov rdx, user_title
call printf

;BEGIN .TEXT POSTREQS
;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

; possible error
movsd xmm0, [rsp]
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
;End of the function helloworld ====================================================================
;END .TEXT POSTREQS

