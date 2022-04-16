[org 0x7c00] ; sets where all pointers will be counted from
             ; 0x7c00 is the memory offset

mov ah, 0x0e
mov bx, string
jmp print_str

string:
    db "What, you egg?", 0

print_str:
    mov al, [bx]
    cmp al, 0 ; if al == 0
    je exit
    int 0x10 ; else print and continue
    inc bx
    jmp print_str
exit:
    jmp $

times 510-($-$$) db 0
db 0x55, 0xaa