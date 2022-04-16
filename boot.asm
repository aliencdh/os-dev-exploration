[org 0x7c00]
KERNEL_LOCATION equ 0x1000

BOOT_DISK: db 0
mov [BOOT_DISK], dl

; clean the registers
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, KERNEL_LOCATION
mov dh, 3

; load sector
mov ah, 2 ; must be 2 to indicate that we're reading from memory
mov al, dh ; the number of sectors to be read

mov ch, 0 ; cylinder number
mov cl, 2 ; sector number
mov dh, 0 ; head number
mov dl, BOOT_DISK ; drive number
mov bx, 0x8000 

int 0x13

; error handling
cmp al, 3
jne incorrect_num_sectors

; clear screen
mov ah, 0x0
mov al, 0x3 ; text mode
int 0x10

;;;;;;; SWITCH TO PROTECTED MODE ;;;;;;;
cli ; disable interrupts
lgdt [GDT_Descriptor]
 ; change last bit of cr0 to 1
mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:start_protected_mode

incorrect_num_sectors:
    mov ah, 0x0e
    int 0x10
    mov bx, msg
    jmp print_str

msg: db "Incorrect number of sectors were read", 0

print_str:
    mov al, [bx]
    cmp al, 0 ; if al == 0
    je exit
    int 0x10 ; else print and continue
    inc bx
    jmp print_str

exit: jmp $

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

[bits 32]
start_protected_mode:
    mov ax, DATA_SEG ; set up segment registers and stack
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_LOCATION ; jump to kernel location

times 510-($-$$) db 0
dw 0xaa55