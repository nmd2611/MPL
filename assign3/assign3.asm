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
	
	msg1 db "Enter HEX number", 0xa
	len1 equ $-msg1

	msg2 db "BCD number is ", 0xa
	len2 equ $-msg2
	
	count db 0
	count2 db 0
	count3 db 0	

section .bss
	
	hexN resb 20
	result resb 20
	;count resb 20
	;count2 resb 20
	;count3 resb 20

section .text

	global _start

_start:

	print msg1,len1
	
	accept result,5

	call AtoH
	
	call HtoB

	mov rax, 60
	mov rdi, 00
	syscall

;	-------------------------- ASCII to HEX ---------------------------------------
AtoH:	
	;xor rsi,rsi
	mov rsi,result
	mov byte[count2],4
	;mov bl,byte[rsi]
	
	xor rax,rax
	
repeat1:cmp byte[rsi], 39h
	jbe down1

	sub byte[rsi],7h
down1:	sub byte[rsi], 30h

	rol ax,4
	add al,byte[rsi]
	inc rsi
	dec byte[count2]
	jnz repeat1
		
	ret

;	-------------------------- HEX to ASCII ---------------------------------------
HtoA:
	;xor rsi,rsi
	mov rsi,result
	mov byte[count], 5 		;This count should be +1 the number of digits

	
up2:	rol ax,4
	mov bl,al
	and bl,0fh
	cmp bl,9h
	jbe down2

	add bl,07h
down2:	add bl,30h

	mov [rsi],bl
	inc rsi
	dec byte[count]
	jnz up2
	
	ret

; ----------------------------------- HEX TO BCD------------------------------------------------

HtoB:

	mov byte[count3],0
	mov rbx,10
	
UP1:	
	xor rdx,rdx
	div rbx
	push rdx
	inc byte[count3]
	cmp rax,0
	jne UP1

LOOP1:	pop rdx
	add rdx, 30h
	mov word[result],dx
	;mov rax,rbx

	;sub rax,30h
	;call HtoA
	print result,1
	dec byte[count3]
	jnz LOOP1
	
	ret

; ------------------------------- BCD TO HEX -------------------------------------------------

BtoH:
	
	xor rax,rax
	mov rbx,10
	mov rcx,5

	xor rdx,rdx
	mul rbx
	mov dl,byte[rsi]
	sub dl,30
	add rax,rdx
	

	ret





