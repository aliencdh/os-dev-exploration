mov ah, 0x0e
mov al, 'A'
int 0x10

; I will use bh to store whether the current letter should be caps or not
mov bh, 0

loop:
    cmp bh, 1 ; if uppercase
    je upper
    ; else
    jmp lower

upper:
    sub al, 32
    inc al
    mov bh, 0
    jmp print

lower:
    add al, 32
    inc al
    mov bh, 1
    jmp print

print:
    cmp al, 'Z' + 1 ; if finished, exit
    je exit
    int 0x10 ; otherwise print and repeat
    jmp loop

exit:
    jmp $

times 510-($-$$) db 0
db 0x55, 0xaa