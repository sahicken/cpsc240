section .data
    NaN db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF8, 0xFF ; IEEE 754 NaN representation

section .text
    global isnan

is_nan:
    ; Input: xmm0 (floating-point value)
    ; Output: ZF set if NaN, ZF clear if not NaN

    ; Compare xmm0 with NaN
    ucomisd xmm0, qword [NaN]

    ; Set ZF if xmm0 is NaN
    setp nz, al

    ret
