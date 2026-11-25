.model small
.stack 100h

.data
    msg1 db 'Enter a number (0-9): $'
    even_msg db 0Dh, 0Ah, 'The number is Even.$'
    odd_msg  db 0Dh, 0Ah, 'The number is Odd.$'

.code
main proc

    mov ax, @data
    mov ds, ax

    mov ah, 9
    lea dx, msg1
    int 21h

    mov ah, 1
    int 21h

    sub al, '0'

    and al, 01h
    jz even

odd:
    mov ah, 9
    lea dx, odd_msg
    int 21h
    jmp exit

even:
    mov ah, 9
    lea dx, even_msg
    int 21h

exit:
    mov ah, 4ch
    int 21h

main endp
end main