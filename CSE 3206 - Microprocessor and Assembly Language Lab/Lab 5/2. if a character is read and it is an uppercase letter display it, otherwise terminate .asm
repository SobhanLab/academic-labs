.model small
.stack 100h
.code

main proc
    mov ah, 1
    int 21h

    cmp al, 'A'
    jb exit 

    cmp al, 'Z'
    ja exit      

    mov ah, 2
    mov dl, al
    int 21h

exit:
    mov ah, 4ch
    int 21h
main endp
end main