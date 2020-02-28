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

	
	msg3 db "Enter BCD number", 0xa
	len3 equ $-msg3

	msg4 db "HEX number is ", 0xa
	len4 equ $-msg4
	
	msg5 db "1.HEX to BCD",0xa,"2. BCD to HEX",0xa,"3. Exit",0xa
	len5 equ $-msg5	
	
	count db 0
	count2 db 0
	count3 db 0	

section .bss
	
	choice resb 20
	hexN resb 20
	result resb 20
	num1 resb 20

section .text

	global _start

_start:

menu:	print msg5,len5	
	accept choice,2	
	
	cmp byte[choice],31h
	je ch1
	
	;cmp byte[choice],32h
	;je ch2

	cmp byte[choice],33h
	je exit

ch1:	print msg1,len1
	
	accept result,5

	call AtoH
	
	call HtoB

	jmp menu

exit:	mov rax, 60
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





