%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall 
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data

	resmsg db "Factorial of the Number is ",0xA
	resmsglen equ $-resmsg
	onemsg db 31h
	

section .bss
	 result resq 1
	 num resq 1
	 cnt resb 4

section .text
	global _start
_start:
	
	xor rbx,rbx
	pop rbx
	pop rbx
	pop rbx
	
	sub byte[rbx],30h
	
	
	cmp dword[rbx],00h
	jne down
	;mov dword[result],01
	print onemsg,1
	jmp EXIT

down: 	xor rax,rax
	mov rax,01h
	call fact 
	call HtoA		
	print result,16	
	

EXIT:	 mov rax,60
     	 mov rdi,0
     	 syscall


fact: 
	cmp word[rbx],01h
	je retlabel
	mul word[rbx]
	dec word[rbx]
	call fact
retlabel:	ret

HtoA:	
	mov rsi,result
	mov byte[cnt],16
	
label1:	rol rax,4
	mov bl,al
	and bl,0fH
	cmp bl,09h
	jbe l4
	add bl,07h
l4:	add bl,30h

	mov [rsi],bl
	inc rsi
	dec byte[cnt]
	jnz label1
	
	ret
	

	
	
	
	

