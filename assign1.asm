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

	msg1 db "Positive Count", 0xA
	len1 equ $-msg1
	
	msg2 db "Negative Count", 0xA
	len2 equ $-msg2

	msg3 db 0xA
	len3 equ $-msg3

	array db 0x10,0xAB, 0x80,0x11,0x98
	
	cnt1 db 5
	

section .bss
	result resb 5
	p resb 5
	n resb 5
	cnt resb 5

section .text

global _start
	
_start:

	mov r8, array
l1:	xor rax,rax
	add al,byte[r8]
	js l2
	inc byte[p]
	
	jmp l3

l2:	inc byte[n]
l3:	inc r8
	dec byte[cnt1]
	jnz l1
	
	print msg1,len1
	mov rax,[p]

	call HtoA
	
	print result,2

	print msg3,len3
 
	print msg2,len2
	mov rax,[n]
	call HtoA
	
	print result,2

	print msg3,len3
 	
	
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

	
	
	



