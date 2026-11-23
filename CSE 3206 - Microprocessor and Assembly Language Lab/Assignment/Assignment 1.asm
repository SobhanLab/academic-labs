.model small
.stack 100h

.data
    array dw 10, 20, 30, 40, 50
    n dw 5

.code
main proc
    mov ax, @data
    mov ds, ax

    lea si, array
    mov bx, n
    call reverse

    mov cx, n
    lea si, array

print:
    mov ax, [si]
    push cx
    call print_num
    pop cx

    mov ah, 02h
    mov dl, ' '
    int 21h

    add si, 2
    loop print

    mov ah, 4ch
    int 21h
main endp

reverse proc
    push ax
    push bx
    push cx
    push si
    push di

    mov di, si
    mov cx, bx
    dec bx
    shl bx, 1
    add di, bx
    shr cx, 1
    jcxz restore

xchg_loop:
    mov ax, [si]
    xchg ax, [di]
    mov [si], ax
    add si, 2
    sub di, 2
    loop xchg_loop

restore:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
reverse endp

print_num proc
    mov bx, 10
    xor cx, cx

divide:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne divide

display:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop display

    ret
print_num endp

end main
