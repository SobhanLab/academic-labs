.model small
.stack 100h

.data
    marks dw 67, 45, 98, 33
          dw 70, 56, 87, 44
          dw 82, 72, 89, 40
          dw 80, 67, 95, 50
          dw 78, 76, 92, 60

.code
main proc
    mov ax, @data
    mov ds, ax

    lea si, marks
    mov bp, 4

exam_loop:
    xor bx, bx
    xor ax, ax
    mov cx, 5

student_loop:
    add ax, [bx+si]
    add bx, 8
    loop student_loop

    xor dx, dx
    mov cx, 5
    div cx

    push dx
    call print_num

    mov ah, 02h
    mov dl, '.'
    int 21h

    pop dx
    add dl, dl
    add dl, 30h
    mov ah, 02h
    int 21h

    mov ah, 02h
    mov dl, ' '
    int 21h

    add si, 2
    dec bp
    jnz exam_loop

    mov ah, 4ch
    int 21h
main endp

print_num proc
    push ax
    push bx
    push cx
    push dx

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

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end main