;****************************************************************************************************************************
; Program name: "Compute Triangle".  This program calculates the average driving time of a driver moving around NOC.     *
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
;  Program name: Compute Triangle
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2024-Feb-19
;  Date of last update: 2024-Feb-23
;  Files in this program: driver.c, manager.asm, isfloat.asm, r.sh, rg.sh
;  Testing: working
;  Status: alpha
;
;Purpose
;  This function and program is a specific computation for triangles
;
;This file:
;  File name: manager.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -l manager.lis -o manager.o manager.asm
;  Assemble (debug): nasm -g dwarf -l manager.lis -o manager.o manager.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double manager();
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
extern atof
extern isfloat
extern cos

global manager

easy_str_sz equ 50 ; strings < 50 bytes

segment .data
;This section (or segment) is for declaring initialized arrays

prompt_name db "Please enter your name: ",0
prompt_title db "Please enter your title (Sargent, Chief, CEO, President, Teacher, etc): ",0
msg_greeting db "Good morning %s %s. We take care of all your triangles.",10,0

prompt_failed db "Invalid input. Try again: ",0
prompt_first_side db "Please enter the length of the first side: ",0
prompt_second_side db "Please enter the length of the second side: ",0
prompt_angle db "Please enter the size of the angle in degrees: ",0

msg_thanks db "Thanks you %s. ",0
msg_entry db "You entered %lf %lf %lf.",10,0
msg_third_side db "The length of the third side is %lf",10,0
msg_driver db "This length will be sent to the driver program.",10,0

deg_to_rad dq 0.01745 ; multiply this constant for conversion

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

name resb easy_str_sz
title resb easy_str_sz

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

; greet the user
mov rax, 0
mov rdi, msg_greeting
mov rsi, title
mov rdx, name
call printf
;END TITLE I/O



; BEGIN FIRST SIDE I/O
; output prompt for first side
mov rax, 0
mov rdi, prompt_first_side
call printf

failed_first_side:

; block that accepts user number and keeps for later validation
sub rsp, 4096
mov rdi, rsp
mov rsi, 4096
mov rdx, [stdin]
call fgets

; block to fix user input
mov rax, 0
mov rdi, rsp
call strlen
; block to remove newline
mov [rsp+rax-1], byte 0

; check if inputted number is float number
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0
jne success_first_side

; skip if success
mov rax, 0
mov rdi, prompt_failed
call printf

; repeat if failed
jmp failed_first_side

success_first_side:

; convert inputted value to float
mov rax, 0
mov rdi, rsp
call atof
movsd xmm15, xmm0
add rsp, 4096
; END FIRST SIDE I/O



; BEGIN SECOND SIDE I/O
; output prompt for first side
mov rax, 0
mov rdi, prompt_second_side
call printf

failed_second_side:

; block that accepts user number and keeps for later validation
sub rsp, 4096
mov rdi, rsp
mov rsi, 4096
mov rdx, [stdin]
call fgets

; block to fix user input
mov rax, 0
mov rdi, rsp
call strlen
; block to remove newline
mov [rsp+rax-1], byte 0

; check if inputted number is float number
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0
jne success_second_side

; skip if success
mov rax, 0
mov rdi, prompt_failed
call printf

; repeat if failed
jmp failed_second_side

success_second_side:

; convert inputted value to float
mov rax, 0
mov rdi, rsp
call atof
movsd xmm14, xmm0
add rsp, 4096
; END SECOND SIDE I/O



; BEGIN ANGLE I/O
; output prompt for first side
mov rax, 0
mov rdi, prompt_angle
call printf

failed_angle:

; block that accepts user number and keeps for later validation
sub rsp, 4096
mov rdi, rsp
mov rsi, 4096
mov rdx, [stdin]
call fgets

; block to fix user input
mov rax, 0
mov rdi, rsp
call strlen
; block to remove newline
mov [rsp+rax-1], byte 0

; check if inputted number is float number
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0
jne success_angle

; skip if success
mov rax, 0
mov rdi, prompt_failed
call printf

; repeat if failed
jmp failed_angle

success_angle:

; convert inputted value to float
mov rax, 0
mov rdi, rsp
call atof
movsd xmm13, xmm0
add rsp, 4096
; END ANGLE I/O



; thank the user
mov rax, 0
mov rdi, msg_thanks
mov rsi, name
call printf

; load entries
movsd xmm0, xmm15
movsd xmm1, xmm14
movsd xmm2, xmm13

; print their entries
mov rax, 3
mov rdi, msg_entry
call printf



;BEGIN LAW OF COSINES
; convert "alpha" to radians
mulsd xmm13, qword [deg_to_rad]

; calculate bc*cos(alpha)
mov rax, 1
movsd xmm0, xmm13
call cos
movsd xmm13, xmm0

; multiply cos(alpha) by 2bc (add bc to bc)
mulsd xmm13, xmm15 ; b
mulsd xmm13, xmm14 ; c
movsd xmm8, xmm13 ; store bc
addsd xmm13, xmm8 ; add bc (to bc)

; square first side
movsd xmm8, xmm15
mulsd xmm15, xmm8

; square second side
movsd xmm8, xmm14
mulsd xmm14, xmm8

; b^2+c^2-2bc*cos(alpha)
addsd xmm15, xmm14
subsd xmm15, xmm13

; square root to get answer
movsd xmm8, xmm15
sqrtsd xmm15, xmm8
;END LAW OF COSINES



;BEGIN .TEXT POSTREQS
;Send back length of "third" side
push qword 0
movsd [rsp], xmm15

;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

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
;END .TEXT POSTREQS (BROKEN)