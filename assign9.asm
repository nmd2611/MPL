%macro print 2
	mov rax,01
	mov rdi,01
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro accept 2
	mov rax,00
	mov rdi,00
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

section .data
        msg1 db "Factorial =  "
        len1 equ $-msg1
        
        msg2 db "001", 0xa
        len2 equ $-msg2
        
        msg3 db "number not zero", 0xa
        len3 equ $-msg3
        
        msgs db  0xa
        lens equ $-msgs
        
        msgone db 31h

section .bss
         result resb 10
         count resb 10
         cnt resb 10
         
section .text
        
global _start

_start:

        xor rbx,rbx
        pop rbx
        pop rbx
        pop rbx
        
        print rbx,02
        
        print msgs,lens
        
        print msg1,len1
        
        sub byte[rbx],30h
        
        cmp byte[rbx],00
        je ZERO
        
        
NOTZERO:
        print msg3,len3
        xor rax,rax
	    mov rax,01h
	    call FACT 
	    call HtoA		
	    print result,16
                
        jmp EXIT
        
ZERO:   
        print msgone,2       
        
        
EXIT:
        mov rax, 60
    	mov rdi, 00
	    syscall
	
FACT: 
	    cmp word[rbx],01h
	    je retlabel
	    mul word[rbx]
	    dec word[rbx]
	    call FACT
retlabel:	ret

HtoA:	
    	mov rsi,result
    	mov byte[cnt],16
	
LOOPUP:
        rol rax,4
    	mov bl,al
    	and bl,0fH
    	cmp bl,09h
    	jbe downn
    	add bl,07h
downn:  add bl,30h
    
    	mov [rsi],bl
    	inc rsi
    	dec byte[cnt]
    	jnz LOOPUP
    	
    	ret
	