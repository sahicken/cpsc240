global producer
extern strlen
extern fputs
extern fgets
extern atof
extern ftoa

max_length equ 256
segment .bss
;This section (or segment) is for declaring empty arrays

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832
section .data
    prompt_side_one db "Please enter the length of side 1: ",0
    prompt_side_two db "Please enter the length of side 2: ",0
    prompt_angle db "Please enter the degrees of the angle between: ",0
    msg_area db "The area of this triangle is ",0
    msg_sqft db " square feet.",10,0
    msg_thx db "Thank you for using a Marvin product.",10,0

section .bss
    side_one resb max_length
    side_two resb max_length
    angle resb max_length
    area resb max_length
section .text
producer:

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

    mov     rdi, prompt_side_one
    call    fputs
    mov     rdi, side_one
    mov     rsi, 10
    call    fgets
    mov     rdi, side_one
    call    atof
    movsd   xmm15, xmm0

    mov     rdi, prompt_side_two
    call    fputs
    mov     rdi, side_two
    mov     rsi, 10
    call    fgets
    mov     rdi, side_two
    call    atof
    movsd   xmm14, xmm0

    mov     rdi, prompt_angle
    call    fputs
    mov     rdi, angle
    mov     rsi, 10
    call    fgets
    mov     rdi, angle
    call    atof
    movsd   xmm13, xmm0

    mov r15, 1
    mov r14, 2
    cvtsi2sd xmm12, r15
    cvtsi2sd xmm11, r14
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14
    mulsd xmm12, xmm13
    divsd xmm12, xmm11

    movsd xmm0, xmm12
    mov rax, 1
    call ftoa
    mov [area], rax

    mov     rdi, msg_area
    call    fputs
    mov     rdi, area
    call    fputs
    mov     rdi, msg_sqft
    call    fputs
    mov     rdi, msg_thx
    call    fputs

    ; put ~answer~ on stack
    push qword 0
    push qword 0
    movsd [rsp], xmm12



    ;------------;-----------BEGIN SEGMENT .TEXT ~POST~ REQS------------;----------------;
    ;Restore the values to non-GPRs
    mov rax,7
    mov rdx,0
    xrstor [backup_storage_area]

    ; return the ~answer~
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
    pop rbp ;Restore rbp to the base of the activation record of the caller program
    ;-------------;----------END SEGMENT .TEXT ~POST~ REQS--------------;----------------;



    ret