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

	msg db "Enter you name", 0xA
	len equ $-msg

section .bss
	name resb 200
	len2 resb 100
	cnt resb 100
	result resb 100

	section .text

	global _start

_start:

	print msg,len

	accept name,200
	
	dec al	
	mov rsi, result
	mov byte[cnt], 02
	
up:	rol al, 04
	mov bl, al
	and bl, 0fh
	cmp bl, 09h
	jbe l2
	add bl, 07h
l2:	add bl, 30h
	
	mov [rsi], bl
	inc rsi
	dec byte[cnt]
	jnz up 

	print result, 02
	;print len2, 20
	

	mov rax, 60
	mov rdi, 00
	syscall
	
	

