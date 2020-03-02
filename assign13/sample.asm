.model tiny
.code
org 0100h
start:
        jmp transit
        save_into dd ?
        hr db 00
        sec db 00
        min db 00
        
resi:
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        push bp
        
        push cs
        pop ds
        
        mov ax, 0b800h
        mov es,ax
        mov di, 1200h
        
        mov ah,02h
        int 1ah
        
        mov hr,ch
        mov min,cl
        mov sec,dh
        mov bh,hr
        cal dis
        
        mov al,3ah
        mov es:[di],al
        inc di
        inc di
        
        mov bh,min
        call dis
        
        mov al,3ah        
        mov al,3ah
        mov es:[di],al
        inc di
        inc di
        
        mov bh,sec
        
        call dis
        
        mov al,3ah
        mov es:[di],al
        inc di
        inc di
        
        pop bp
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        
        jmp cs : save_into
        
        
        
transit:
        
        cli
        push cs
        pop ds
        mov ax,3h
        int 10h
        mov ah,35h
        mov al,1ch
        int 2h
        
        
        mov word ptr save_into,bx
        mov word ptr save_into+2, es
        
        mov ah,25h
        mov al,1ch
        mov dx,offset resi
        int 21h
        
        mov ah,31h
        mov al,1h
        mov dx,offset transit
        sti
        int 21h
        end
        
        
        
        
