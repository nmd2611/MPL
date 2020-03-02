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
	; final Overlapping Method of Block Transfer
section .data
	
	msg1 db "Array 1",0xa
	len1 equ $-msg1

	msg2 db "Array 2",0xa
	len2 equ $-msg2

	msg3 db " : "
	len3 equ $-msg3

	msg4 db 0xa
	len4 equ $-msg4
	
	block1 dq 0x999,0x888,0x777,0x555,0x444,0x000,0x0,0x0,0x0
	block2 dq 0x000,0x000,0x000, 0x000,0x000,0x000,0x000,0x000,0x000
	count1 db 9
	count2 db 5   	; count of useful elements
	count3 db 9 

section .bss
	count resb 20
	result resq 20	

section .text

	global _start

_start:
	
	print msg1,len1
	mov rsi, block1

l2:	mov rax, rsi
	
	call HtoA
	push rsi
	print result,16
	print msg3,len3
	pop rsi
	mov rax,qword[rsi]
	call HtoA
	push rsi
	print result,16
	print msg4,len4 
	pop rsi
	add rsi,8
	dec byte[count1]
	jnz l2
	
	; array 1 printed

	; reset the pointers
	mov rsi, block1
	mov rdi, block1

	add rsi, 32
	add rdi, 64

	; block transfer
	xor rax,rax
loop1:	mov rax, qword[rsi]
	mov qword[rdi],rax
	sub rsi,8
	sub rdi,8
	dec byte[count2]
	jnz loop1
	

	xor rdi,rdi
	; memory blocks transferred uptill here

	print msg2,len2
	;reset rsi and rdi
	mov rsi, block1
	
	;mov rdi, block2
	
	xor rax,rax


l3:	mov rax, rsi
	
	call HtoA
	push rsi
	print result,16
	print msg3,len3
	pop rsi
	mov rax,qword[rsi]
	call HtoA
	push rsi
	print result,16
	print msg4,len4 
	pop rsi
	add rsi,8
	dec byte[count3]
	jnz l3
	
	

	mov rax, 60
	mov rdi, 00
	syscall

HtoA:
	mov rdi,result
	mov byte[count],16
	
up:	rol rax,4
	mov bl,al
	and bl,0fh
	cmp bl,9h
	jbe l1

	add bl,07h
l1:	add bl,30h

	mov [rdi], bl
	inc rdi
	dec byte[count]
	jnz up
	
	ret

	


