; in order to read a new sector, you need to know:
; 1. what disk to read from
; 2. CHS address
; 3. how many sectors?
; 4. where in memory should it be loader?

[org 0x7c00]
mov [diskNum], dl

; code I don't understand 
; xor ax, ax
; mov es, ax
; mov ds, ax
; mov bp, 0x8000
; mov sp, bp

; load sector
mov ch, 0 ; cylinder number
mov cl, 2 ; sector number
mov dh, 0 ; head number
mov dl, [diskNum] ; drive number
; es:bx pointer to where we want to load the sectors
; es is the extra segment
mov ax, 0 ; you can only move values from another register into es
mov es, ax
mov bx, 0x7e00 ; 0x7c00 + 512
mov ah, 2 ; must be 2 to indicate that we're reading from memory
mov al, 1 ; the number of sectors to be read

int 0x13

; print stuff
mov ah, 0x0e
mov al, [0x7e00]
int 0x10

diskNum: db 0

times 510-($-$$) db 0
db 0x55, 0xaa

times 512 db 'A' ; outside the portion read by the bootloader