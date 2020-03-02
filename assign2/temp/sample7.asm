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
; Non Overlapping Block transfer (without string instructions)

section .data
	
	msg1 db "Array 1",0xa
	len1 equ $-msg1

	msg2 db "Array 2",0xa
	len2 equ $-msg2

	msg3 db " : "
	len3 equ $-msg3

	msg4 db 0xa
	len4 equ $-msg4
	
	block1 dq 0x1111111111111111,0x6611111111123151,0x8713412111123151
	block2 dq 0x0000000000000000,0x0000000000000000,0x0000000000000000
	count1 db 3
	count2 db 3
	count3 db 3 

section .bss
	count resb 20
	result resq 20	

section .text

	global _start

_start:
	
	print msg1,len1
	mov rsi, block1
	mov rdi, block2

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
	
	; reset the pointers
	mov rsi, block1
	mov rdi, block2

	; block transfer
	xor rax,rax
loop1:	mov rax, qword[rsi]
	mov qword[rdi],rax
	add rsi,8
	add rdi,8
	dec byte[count2]
	jnz loop1
	

	xor rdi,rdi
	; memory blocks transferred uptill here

	print msg2,len2
	;reset rsi and rdi
	mov rsi, block2
	
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

	


