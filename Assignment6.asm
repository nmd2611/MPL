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

msgreg db "*************REGISTER CONTENTS******************",0xA
msgreglen equ $-msgreg

msgg db "Contents of GDTR",0xA
msgglen equ $-msgg
msgl db "Contents of LDTR",0xA
msgllen equ $-msgl
msgi db "Contents of IDTR",0xA
msgilen equ $-msgi

msgreal db "IN REAL MODE",0xA
msgreallen equ $-msgreal

msgproct db "IN PROTECTED MODE",0xA
msgproctlen equ $-msgproct

msgnewline db 0xA
msgnewlinelen equ $-msgnewline
cnt db 00

section .bss
g :resd 01
   resw 01	
idtr: resd 01
      resw 01
l resw 01
result resb 4
msw resd 1
value resb 4



section .text
global _start
_start:
	
	
	smsw [msw]
	mov eax,dword[msw]
	bt eax,0
	jc next
	print msgreal,msgreallen
	jmp EXIT

next:	
	print msgproct,msgproctlen

	print msgreg,msgreglen
	
	

	print msgg,msgglen
	sgdt [g]
	mov ax,[g+4]
	call HtoA
	mov ax,[g+2]
	call HtoA
	mov ax,[g]
	call HtoA
	
	print msgnewline,msgnewlinelen




	print msgl,msgllen
	sldt [l]
	mov ax,[l]
	call HtoA

	print msgnewline,msgnewlinelen



	print msgi,msgilen
	sidt [idtr]
	mov ax,[idtr+4]
	call HtoA
	mov ax,[idtr+2]
	call HtoA
	mov ax,[idtr]
	call HtoA	


EXIT:   mov rax,60
	mov rdi,00
	syscall	


HtoA:
	mov rsi, result
	mov byte[cnt],4
	
loop:	rol ax, 04
	mov bl, al
	and bl, 0FH
	cmp bl, 09H
	jbe label
	add bl, 07H
label:	add bl, 30H
	mov byte[rsi],bl
	inc rsi
	dec BYTE[cnt]
	
	jnz loop
	print result, 04
ret






































