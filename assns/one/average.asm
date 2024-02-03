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

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global average

name_string_size equ 48
title_string_size equ 48



segment .data
;This section (or segment) is for declaring initialized arrays

prompt_for_name db "Please enter your first and last names: ",0
prompt_for_title db "Please enter your title such as Lieutenant, Chief, Mr, Ms, Influencer, Chairman, Freshman, Foreman, Project Leader, etc: ",0
thanks db "Thank you %s %s",10,0

ful_sna_mi db "Enter the number of miles traveled from Fullerton to Santa Ana: ",0
ful_sna_mph db "Enter your average speed during that leg of the trip: ",0

sna_lbc_mi db "Enter the number of miles traveled from Santa Ana to Long Beach: ",0
sna_lbc_mph db "Enter your average speed during that leg of the trip: ",0

lbc_ful_mi db "Enter the number of miles traveled from Long Beach to Fullerton: ",0
lbc_ful_mph db "Enter your average speed during that leg of the trip: ",0

double_format_specifier db "%lf",0 ;check if null char needed

processing db "The inputted data are being processed",10,0

distance_msg db "The total distance traveled is %1.6lf miles",10,0

float_three db 3.0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832 ; why 832 [?]

user_name resb name_string_size
user_title resb title_string_size



segment .text

average:

;Back up the GPRs (General Purpose Registers)
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

;Backup the registers other than the GPRs
mov rax,7
mov rdx,0
xsave [backup_storage_area] ; purpose [?]


;BEGIN USER NAME I/O
;Output prompt for the user (name)
mov rax, 0
mov rdi, prompt_for_name
call printf

;Input user's name
mov rax, 0
mov rdi, user_name
mov rsi, name_string_size
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
mov rsi, title_string_size
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

;ful>sna
mov rax, 0
mov rdi, ful_sna_mi
call printf

;mov rax, 0
mov rdi, double_format_specifier
push qword 0
push qword 0
mov rsi, rsp
call scanf
movsd xmm15, [rsp]
pop rax
pop rax

;;;;;;;;;;;;;;;;;;;;;
; distance msg
mov rax, 0
mov rdi, distance_msg
movsd xmm0, xmm15
call printf
;;;;;;;;;;;;;;;;;;;

mov rax, 0
mov rdi, ful_sna_mph
call printf

mov rax, 0
mov rdi, double_format_specifier
mov rsi, rsp
call scanf
movsd xmm14, [rsp] ; prev xmm2

;sna>lbc
mov rax, 0
mov rdi, sna_lbc_mi
call printf

mov rax, 0
mov rdi, double_format_specifier
mov rsi, rsp
call scanf
movsd xmm13, [rsp] ; prev xmm3


mov rax, 0
mov rdi, sna_lbc_mph
call printf

mov rax, 0
mov rdi, double_format_specifier
mov rsi, rsp
call scanf
movsd xmm12, [rsp] ; prev xmm4

;lbc>sna
mov rax, 0
mov rdi, lbc_ful_mi
call printf

mov rax, 0
mov rdi, double_format_specifier
mov rsi, rsp
call scanf
movsd xmm11, [rsp] ; prev xmm5


mov rax, 0
mov rdi, lbc_ful_mph
call printf

mov rax, 0
mov rdi, double_format_specifier
mov rsi, rsp
call scanf
movsd xmm10, [rsp] ; prev xmm6

; let user know we're processing
mov rax, 0
mov rdi, processing
call printf

; total distance in xmm1
addsd xmm15, xmm13
addsd xmm15, xmm11

; total speed in xmm2
addsd xmm14, xmm12
addsd xmm14, xmm10

; avg speed in xmm3 (speed/3)
movsd xmm13, xmm14
divsd xmm13, qword [float_three]

; time in xmm4 (dist / avg)
movsd xmm12, xmm15
divsd xmm12, xmm13



; time msg
;mov rax, 0
;mov rdi, time_msg_a
;cvtsd2si rsi, xmm12
;mov rdx, time_msg_b
;call printf

; speed msg
; rax, 0
;mov rdi, speed_msg_a
;cvtsd2si rsi, xmm13
;mov rdx, speed_msg_b
;call printf

;;;;FROM ASSN 0--NEED PARTS OF THIS STILL;;;;

;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

;Send back the avg speed
cvtsd2si rax,xmm13

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

