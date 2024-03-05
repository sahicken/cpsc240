extern printf
extern scanf
extern isfloat
extern atof

; name of "this" asm file/fxn
global input_array

section .data

invalid db "The last input was invalid and not entered into the array.",10,0
fmt_str db "%s",0

section .bss

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

section .text

input_array:

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

mov r13, rdi   ; pointer to front of array
mov r14, rsi   ; size of array (# elements)
mov r15, 0     ; counter = 0 (change to rcx)
sub rsp, 1024  ; set asisde space on stack

;---------------------------------START OF LOOP---------------------------------------------
begin_loop:

; Scanf function called to take user input.
mov rax, 0
mov rdi, fmt_str
mov rsi, rsp
call scanf

; Tests if Control + D is entered to finish inputing into array.
cdqe
cmp rax, -1
je end_of_loop ; If control + D is entered, jump to end_of_loop.

;------------------------------INPUT VALIDATION---------------------------------------------
; Checks to see if each character in the input string of integers is from 0 to 9.

mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0                              ; Checks to see if isinteger returned true/false.
je invalid_input                        ; If isinteger returns 0. jump to not_an_int label.

;---------------------------------ASCII TO LONG---------------------------------------------
; Converts string of characters (user input) into a long integer. 

mov rax, 0
mov rdi, rsp
call atof

;--------------------------------COPY INTO ARRAY--------------------------------------------
; Adds copy of long integer saved in r12 into array at index of counter (r13).

movsd [r13 + 8 * r15], xmm0                ; Copies user input into array at index of r13.
inc r15                                ; Increments counter r13 by 1.

;-----------------------------ARRAY CAPACITY TEST-------------------------------------------
; Tests to see if max array capacity has been reached.
cmp r13, r14                            ; Compares # of elements (r13) to capacity (r14).
je exit                                 ; If # of elements equals capacity, exit loop.

; Restarts loop.
jmp begin_loop

;--------------------------------INVALID INPUT----------------------------------------------
; Prints out invalid input statement and restarts loop and pops stack to offset initial push
; at the beginning of the loop.

invalid_input:
mov rdi, stringFormat
mov rsi, invalid 
mov rax, 0
call printf
jmp begin_loop                         ; Restarts loop.

;---------------------------------END OF LOOP-----------------------------------------------

; After control+D is entered the loop is skipped and so is the pop in the loop
; therefore this controlD block makes up for that missed pop.
end_of_loop:
add rsp, 1024


;BEGIN .TEXT POSTREQS

;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

;return value size
mov rax, r15

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
