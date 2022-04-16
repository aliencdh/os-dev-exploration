mov bp, 0x8000 ; set the stack base
mov sp, bp ; set the stack top

mov bh, 'A'
push bx

mov bh, 'B'
mov ah, 0x0e
mov al, bh
int 0x10

pop bx
mov ah, 0x0e
mov al, bh
int 0x10

jmp $
times 510-($-$$) db 0
db 0x55, 0xaa