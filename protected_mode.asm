[org 0x7c00]
mov [BOOT_DISK], dl

cli ; disable interrupts
lgdt [GDT_Descriptor]
 ; change last bit of cr0 to 1
mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:start_protected_mode

; far jump (jmp to other segment)

; code segment descriptor
; - present = 1 for used segments
; - privilege = 00 ("ring 0")
; - type = 1 if code or data segment
; - flags = {bool}
; sets of flags:
; - type flags (4 bits)
;       values: 
;            contains code?                                             1 
;            can this code be executed from lower privilege segments?   0
;            readable? (allows reading of constants)                    1
;            accessed? used by the CPU, not manually                    0
; - other flags (4 bits)
;       values:
;           granularity: limit * 0x1000                                 1
;           32 bits                                                     1
;                                                                       0
;                                                                       0

; data segment descriptor
; --||--
; type flags = 0010
;   2 - direction
;   3 - writeable

GDT_Start:
    ; at the beginning of every GDT, there must be an empty descriptor
    null_descriptor:
        dd 0
        dd 0
    code_descriptor:
        ; first 16 bits of limit
        dw 0xffff
        ; base
        dw 0 ; 16 bits
        db 0 ; + 8 bits = 24 bits
        ; pres, priv, type = 1001
        ; type flags = 1010
        db 10011010b
        ; other + last 4 bits of limit
        db 11001111b
        db 0
    data_descriptor:
        ; first 16 bits of limit
        dw 0xffff
        ; base
        dw 0
        db 0
        ; pre, priv, type + type
        db 10010010b
        db 11001111b
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; size
    dd GDT_Start

; offsets
CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

BOOT_DISK: db 0

[bits 32]
start_protected_mode:
    ; in protected mode, you print by manipulating video memory directly
    mov al, 'A'
    mov ah, 0x0f ; white on black
    mov [0xb8000], ax

times 510-($-$$) db 0
dw 0xaa55