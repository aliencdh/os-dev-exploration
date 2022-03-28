; how to print a char:
; 1. switch to teletype mode
mov ah, 0x0e
; set the character to be printed
mov al, 'H'

; 2. call BIOS interrupt 0x10
int 0x10

; e
mov ah, 0x0e
mov al, 'e'
int 0x10

; l
mov ah, 0x0e
mov al, 'l'
int 0x10

; l
mov ah, 0x0e
mov al, 'l'
int 0x10

; o
mov ah, 0x0e
mov al, 'o'
int 0x10

; \s
mov ah, 0x0e
mov al, ' '
int 0x10

; W
mov ah, 0x0e
mov al, 'W'
int 0x10

; o
mov ah, 0x0e
mov al, 'o'
int 0x10

; r
mov ah, 0x0e
mov al, 'r'
int 0x10

; l
mov ah, 0x0e
mov al, 'l'
int 0x10

; d
mov ah, 0x0e
mov al, 'd'
int 0x10

; !
mov ah, 0x0e
mov al, '!'
int 0x10

; loop infinitely
jmp $
; fill up to 510 bytes with 0s (because a bootable disk can only have 512 bytes)
times 510-($-$$) db 0
; define the last 2 bytes (if the values aren't set to that,
; the system will not recognize this as a bootable HD)
db 0x55, 0xaa