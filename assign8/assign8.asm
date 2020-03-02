%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro read 2
	mov rax, 0		
	mov rdi, 0		
	mov rsi, %1		
	mov rdx, %2		
	syscall			
%endmacro


section .data
	msg db "HII",0xA
	msglen equ $-msg


section .bss
	fname resb 4
	fname1 resb 4
	buffer resb 200
	fd_in resb 8
	fdd_in resb 8
	count2 resb 5
	count3 resb 5

section .text

global _start

_start:

	xor rbx,rbx
	pop rbx
	pop rbx
	pop rbx
	

	cmp byte[rbx],'T'
	je type
	cmp byte[rbx],'C'
	je copy
	cmp byte[rbx],'D'
	je delete



type: 
	;print msg,msglen

	
		

	pop rbx
	mov [fname],rbx

	mov rax,2		;syscall for file opening
	mov rdi,[fname]
	mov rsi,2
	mov rdx,0777
	syscall	
	mov [fd_in],rax	


	mov rax,0		;syscall for reading from a file
	mov rdi,[fd_in]
	mov rsi,buffer
	mov rdx,200
	syscall

	mov [count2],rax

	print buffer,[count2]


copy: 
	
	pop rbx
	mov [fname],rbx
	
	
	mov rax,2		;syscall for file opening
	mov rdi,[fname]
	mov rsi,2
	mov rdx,0777
	syscall	
	mov [fd_in],rax	


	mov rax,0		;syscall for reading from a file
	mov rdi,[fd_in]
	mov rsi,buffer
	mov rdx,300
	syscall
	
	
	mov [count2],rax
	
	
	mov rax,3
	mov rdi,[fd_in]
	syscall
		
	;print buffer,[count2]
	pop rbx
	mov [fname1],rbx

	mov rax,2		;syscall for file opening
	mov rdi,[fname1]
	mov rsi,2
	mov rdx,0777
	syscall	
	mov [fdd_in],rax	

	;print buffer,[count2]
	mov rax,1
	mov rdi,[fdd_in]
	mov rsi,buffer
	mov rdx,[count2]
	syscall

delete:
	pop rbx
	mov [fname],rbx

	mov rax,2		;syscall for file opening
	mov rdi,[fname]
	mov rsi,2
	mov rdx,0777
	syscall	
	mov [fd_in],rax	

	mov rax,87
	mov rdi,[fname]
	syscall


Exit:
	mov rax,60
	mov rdi,00
	syscall



