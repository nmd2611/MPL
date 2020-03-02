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

	msg1 db "Numbers are", 0xA
	len1 equ $-msg1

	msg3 db 0xA
	len3 equ $-msg3

	array db 0x78,0xAB, 0x80,0x11,0x98
	
	cnt1 db 5


section .bss
	result resb 5
	cnt resb 5


section .text
	
global _start

_start:
	
	print msg1, len1

	mov r8, array
loop:	xor rax,rax
	
	add al, byte[r8]
	
	call HtoA
	print result,2

	print msg3, len3
	
	xor rax,rax
	add rax, r8

	call HtoAdd
	print result,16
	
	print msg3, len3

	inc r8
	dec byte[cnt1]
	
	jnz loop

	
	mov rax, 60
	mov rdi, 00
	syscall

HtoA:
	mov rsi, result
	mov byte[cnt], 02
	
label1:	rol al, 04
	mov bl, al
	and bl, 0fh
	cmp bl, 09h
	jbe l4

	add bl, 07h
l4:	add bl, 30h
	
	mov [rsi], bl
	inc rsi
	dec byte[cnt]
	jnz label1

	ret


HtoAdd:
	mov rsi, result
	mov byte[cnt], 16
	
label2:	rol rax, 16
	mov bl, al
	and bl, 0fh
	cmp bl, 09h
	jbe loop2

	add bl, 07h
loop2:	add bl, 30h
	
	mov [rsi], bl
	inc rsi
	dec byte[cnt]
	jnz label2

	ret


