.model small
.stack 100h

.data
    a     db 'Enter the character y or Y: $'
    msg_1 db '*VU_CSE* $'
    msg_2 db 'The input character is not "y" or "Y".$'

.code
main proc

    mov ax, @data
    mov ds, ax

    mov ah, 9
    lea dx, a
    int 21h

    mov ah, 1
    int 21h
    mov bl, al

    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h

    cmp bl, 'y'
    je display

    cmp bl, 'Y'
    je display

    mov ah, 9
    lea dx, msg_2
    int 21h

    jmp exit

display:
    mov ah, 9
    lea dx, msg_1
    int 21h

exit:
    mov ah, 4ch
    int 21h

main endp
end main
