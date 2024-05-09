; name of "this" asm file/fxn
global is_nan

section .bss
align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

section .text
is_nan:
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

    mov r15, rdi ; checking this ieee754 number
    mov r14, 0x7FF00000 ; stored exp is all 1s
    and r15, r14 ; get rid of other bits
    cmp r15, r14 ; is r15 stored exp all 1s?
    je .nan_detected
    jmp .not_nan

.nan_detected:
    ; Set the zero flag to indicate NaN
    mov rax, 1
    jmp cleanup

.not_nan:
    ; Clear the zero flag to indicate not NaN
    mov rax, 0
    jmp cleanup

cleanup:
    ;------------;-----------BEGIN SEGMENT .TEXT ~POST~ REQS------------;----------------;
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
    pop rbp ;Restore rbp to the base of the activation record of the caller program
    ;-------------;----------END SEGMENT .TEXT ~POST~ REQS--------------;----------------;

    ret