[org 0x7c00]

mov ah, 99
mov [print_int_in], ah
call print_int
jmp exit

digit_to_char:
    mov ah, [digit_to_char_in]
    add ah, 48

    mov [digit_to_char_out], ah
    ret

digit_to_char_in: db 0
digit_to_char_out: db 0

print_int:
    mov bx, [print_int_in]
    ; print first digit
    mov ax, bx
    and ax, 200
    mov ch, 100
    div ch

    mov [digit_to_char_in], al
    call digit_to_char
    mov ah, 0x0e
    mov al, [digit_to_char_out]
    int 0x10

    ; print 2nd digit
    mov ax, bx
    and ax, 50
    mov ch, 10
    div ch

    mov [digit_to_char_in], al
    call digit_to_char
    mov ah, 0x0e
    mov al, [digit_to_char_out]
    int 0x10

    ; print last digit
    mov ax, bx
    and ax, 5

    mov [digit_to_char_in], al
    call digit_to_char
    mov ah, 0x0e
    mov al, [digit_to_char_out]
    int 0x10

    ret

print_int_in: db 0

exit:
    jmp $

; padding for the BIOS
times 510-($-$$) db 0
db 0x55, 0xaa