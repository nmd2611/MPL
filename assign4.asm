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
	msg1 db "Answer using Successive Addition is",0xa
	len1 equ $-msg1
	
	msg2 db "Answer using Booth's Algo",0xa
	len2 equ $-msg2
	
	msg3 db 0xa
	len3 equ $-msg3

	num1 db 0x04
	num2 db 0x08
	count db 08h

section .bss
	
	result resb 5
	result2 resb 5
	cnt resb 10


section .text

	global _start

_start:

	print msg1,len1
	
	xor rax,rax
	mov bl ,[num2]
	mov cl, [num1]
	
Add:	add ax,bx
	loop Add

	call HtoA
	
	print result,5		; print successive addition
	print msg3,len3		; print space

; -------------- BOOTHS ALGO ----------------------

	print msg2,len2		;print message for booths algo
	
	xor rax,rax		; clear the accumulator
	xor rsi,rsi
	xor rbx,rbx
	xor rcx,rcx
	
	mov bl,[num2]		; multiplier
	mov cl,[num1]		; multiplicand
	
repeat1:
	shl al,01
	rcl bl,01
	
	jc addnum
	
	jmp adddec

addnum:	add ax,cx	
	
	
adddec:	dec byte[count]
	jnz repeat1
	
	call HtoA2
	
	print result2,5		; print successive addition
	print msg3,len3		; print space

	mov rax, 60
	mov rdi, 00
	syscall
;------------------------------------------ PROCEDURES -------------------------------------------------

HtoA:
	xor rsi,rsi
	mov rsi, result
	mov byte[cnt], 04
	
label1:	rol ax, 04
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

;------------------------------ HtoA2 -------------------------------

HtoA2:
	xor rsi,rsi
	mov rsi, result2
	mov byte[cnt], 04
	
label2:	rol ax, 04
	mov bl, al
	and bl, 0fh
	cmp bl, 09h
	jbe l5

	add bl, 07h
l5:	add bl, 30h
	
	mov [rsi], bl
	inc rsi
	dec byte[cnt]
	jnz label2

	ret








