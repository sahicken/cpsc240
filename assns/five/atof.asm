;************************************************************************************************************************
;Program name: "atolong".  This program accepts an array of char and converts that array to its corresponding integer   *
;value.  This is a library function not specific to any one program.  Copyright (C) 2018  Floyd Holliday                *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public      *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will  *
;be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  *
;PURPOSE.  See the GNU General Public License for more details.  A copy of the GNU General Public License v3 is         *
;available here:  <https://www.gnu.org/licenses/>.                                                                      *
;************************************************************************************************************************

;Author information
;   Author name: Floyd Holliday
;   Author's email: holliday@fullerton.edu

;Function information
;   Function name: atolong
;   Programming language: X86
;   Language syntax: Intel
;   Function prototype:  long int atolong (char * number_string); 
;   Reference: None
;   Input parameter: The char array passed to this function must contain valid integral data.
;   Output parameter: A long integer that is faithfully represented by the incoming parameter.

;Assemble: nasm -f elf64 -o atol.o -l atol.lis atol.asm

;Date development began: 2018-March-28
;Date comments restructured: 2022-July-16

;Names
;   The function "atolong" was intended to be called atol, however there already is a function in the C++ standard library
;   with that name.  To avoid any possible conflict this function received the longer name, namely: atolong.  A simple web
;   search will produce lots of information about the original atol.

;===== Begin executable code section ====================================================================================

;Assembler directives
base_number equ 10                      ;10 base of the decimal number system
ascii_zero equ 48                       ;48 is the ascii value of '0'
null equ 0
minus equ '-'
decimal_point equ '.'

;Global declaration for linking files.
global atof                          ;This makes atolong callable by functions outside of this file.

segment .data                           ;Place initialized data here
   ;This segment is empy

segment .bss        
                    ;Declare pointers to un-initialized space in this segment.
                    align 64
   ;This segment is empty
   ; [ 12.34, 23.5] resq (64 bits)
   ; ['a', 'b', 'c'] (8 bits (1 byte) per element)
   float_as_string_arr resb 100
   ;This section (or segment) is for declaring empty array
   ; required for xstor and xrstor instructions
   backup_storage_area resb 832

;==============================================================================================================================
;===== Begin the executable code here.
;==============================================================================================================================
segment .text                           ;Place executable instructions in this segment.

atof:                                   ;Entry point.  Execution begins here.

    ;---------BEGIN SEGMENT .TEXT ~PRE~ REQS----------;
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
    ;----------END SEGMENT .TEXT ~PRE~ REQS------------;

    ; save the arguments
    movsd xmm15, xmm0
    ; multiply by 10 until we get this -> 15623

    xorpd xmm12, xmm12 ; just to have a 0.0 to compare
    ; 156.23 -> 15623
    mov r11, 0
whileLoop:
    ; 156.23 - 156
    ; original_num - int_converted_num
    ; original_num - the original float is in xmm15
    cvtsd2si r15, xmm15 ; original_num
    cvtsi2sd xmm14, r15 ; int_converted_num
    
    movsd xmm13, xmm15
    subsd xmm13, xmm14 ; xmm13 = original_num - int_converted_num

    ucomisd xmm13, xmm12
    je OutOfLoop
    ; else
    mov rax, 10
    cvtsi2sd xmm11, rax
    ; 156.23 * 10 -> 1562.3
    mulsd xmm15, xmm11
    inc r11
    jmp whileLoop

OutOfLoop:
    ;------------;-----------BEGIN SEGMENT .TEXT ~POST~ REQS------------;----------------;
    ;Restore the values to non-GPRs
    mov rax,7
    mov rdx,0
    xrstor [backup_storage_area]
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
    pop rbp ;Restore rbp to the base of the activation record of the caller program
    ;-------------;----------END SEGMENT .TEXT ~POST~ REQS--------------;----------------;
    
            ;Now the system stack is in the same state it was when this function began execution.
    ret     ;Pop a qword from the stack into rip, and continue executing..
;========== End of module atol.asm ================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**