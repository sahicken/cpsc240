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



; BEGIN LOOP
begin_loop:
; take user input
mov rax, 0
mov rdi, fmt_str
mov rsi, rsp
call scanf

; tests ctrl-D (several 1's aka -1)
cdqe
cmp rax, -1
je end_loop

; now validate the input
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0                    ; Checks to see if isfloat is false
je invalid_input              ; jump to invalid_input if false

mov rax, 0
mov rdi, rsp
call atof
movsd [r13 + 8 * r15], xmm0   ; Copies float into array

inc r15                       ; Increments counter (by 1)
; Tests array capacity
cmp r15, r14                  ; Compares current index with size
je end_loop                   ; If index equals size, exit
; Restarts loop.
jmp begin_loop

; inform user of invalid input
invalid_input:
mov rax, 0
mov rdi, fmt_str
mov rsi, invalid 
call printf
jmp begin_loop ; repeat loop
; END LOOP



; loop ends after ctrl-D
end_loop:
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
