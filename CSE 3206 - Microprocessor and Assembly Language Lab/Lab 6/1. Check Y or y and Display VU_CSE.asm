.model small
.stack 100h
.code

.data
    a     db 'Enter the character y or Y: $'
    msg_1 db 10,13, '*VU_CSE* $'
    msg_2 db 10,13, 'The input character is not "y" or "Y". $'

main proc

    mov ax, @data
    mov ds, ax

    mov ah, 9
    lea dx, a
    int 21h

    mov ah, 1
    int 21h
    mov bl, al

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