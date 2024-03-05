extern printf
extern scanf
extern isfloat

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









;;;;;;;;;;;;;;;;;;begin new dev;;;;;;;;;;;;;;;;;;;









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

mov qword rax, 0
mov qword rdi, rsp
call isinteger
cmp rax, 0                              ; Checks to see if isinteger returned true/false.
je invalid_input                        ; If isinteger returns 0. jump to not_an_int label.

;---------------------------------ASCII TO LONG---------------------------------------------
; Converts string of characters (user input) into a long integer. 

mov qword rax, 0
mov qword rdi, rsp
call atolong                            
mov qword r12, rax                      ; Saves output long integer from atolong in r12.
pop r8                                  ; Pop off stack into any scratch register. 

;--------------------------------COPY INTO ARRAY--------------------------------------------
; Adds copy of long integer saved in r12 into array at index of counter (r13).

mov [r15 + 8 * r13], r12                ; Copies user input into array at index of r13.
inc r13                                 ; Increments counter r13 by 1.

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
pop r8                                 ; Pop off stack to any scratch register.  
jmp begin_loop                         ; Restarts loop.

;---------------------------------END OF LOOP-----------------------------------------------

; After control+D is entered the loop is skipped and so is the pop in the loop
; therefore this controlD block makes up for that missed pop.
end_of_loop:
pop r8                                  ; Pop off stack into any scratch register.                

;------------------------------------EXIT---------------------------------------------------
exit:

mov qword rax, r13                      ; Copies # of elements in r13 to rax.








;;;;;;;;;;;;;;;;;;end new dev;;;;;;;;;;;;;;;;;;;








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
