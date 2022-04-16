; how to read a key:
; mov ah, 0
; int 0x16 ; BIOS interrupt: the system waits for a key press
          ; output: al = ASCII char, ah = Scancode

mov bx, buffer
mov dx, bx
add dx, 9
jmp get_str

buffer:
    times 11 db 0

; get_str
get_str:
    cmp bx, dx ; a pointer to the final element of the buffer will be stored in dx 
    je get_str_exit

    mov ah, 0
    int 0x16 ; get char
    mov [bx], al ; deposit char
    inc bx ; inc and repeat
    jmp get_str

get_str_exit:
    mov bx, buffer
    jmp print_str
; get_str

; print_str
print_str:
    mov ah, 0x0e
    mov al, [bx]
    cmp al, 0 ; if al == 0
    je print_str_exit
    int 0x10 ; else print and continue
    inc bx
    jmp print_str
print_str_exit:
    jmp $
; print_str

times 510-($-$$) db 0
db 0x55, 0xaa