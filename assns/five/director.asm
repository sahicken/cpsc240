global _start
extern fputs
extern fgets
extern ftoa
extern producer
max_length equ 256

section .data
    msg_welcome db "Welcome to Marvelous Marvin’s Area Machine.",10,0
    msg_purpose db "We compute all your areas.",10,0
    msg_rx_aofd db "The driver received this number ",0
    msg_rx_bofd db " and will keep it. ",10,0
    msg_rx_cofd db "A zero will be sent to the OS as a sign of successful conclusion.",10,0
    msg_rx_dofd db "Bye",10,0
section .bss
    nice_number resb max_length
section .text
_start:
    mov     rdi, msg_welcome
    call    fputs

    mov     rdi, msg_purpose
    call    fputs

    call producer
    movsd xmm15, xmm0
    mov rax, 1
    call ftoa
    mov [nice_number], rax

    mov     rdi, msg_rx_aofd
    call    fputs

    mov     rdi, nice_number
    call    fputs

    mov     rdi, msg_rx_bofd
    call    fputs

    mov     rdi, msg_rx_cofd
    call    fputs

    mov     rdi, msg_rx_dofd
    call    fputs

    ; Exit
    mov        rax, 60
    mov        rdi, 0
    syscall