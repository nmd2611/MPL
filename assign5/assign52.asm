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


global space 
global newline
global character
global openfile
global readfile
global writefile
global closefile
global exit
global HtoA

extern scount
extern lenf
extern lenf2
extern lenf3
extern fin
extern buffer
extern cnt
extern count
extern result

extern fname
extern msg1
extern len1
extern msg2
extern len2
extern msg5
extern len5
extern msg4
extern len4
extern msg6
extern len6
extern buffer2
extern len3
extern searchC


section .data

openfile:
	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx, 0777
	syscall
	
	mov [fin], rax
	ret

readfile:
	mov rax,0
	mov rdi,[fin]
	mov rsi,buffer
	mov rdx, 40
	syscall
	
	dec rax

	ret

writefile:
	mov rax,01
	mov rdi,[fin]
	mov rsi, buffer2
	mov rdx, len3
	syscall

	ret

closefile:
	mov rax,3
	mov rdi,[fin]
	syscall
	
	ret

exit:
	mov rax, 60
	mov rdi, 00
	syscall
	
	ret
		

HtoA:
	xor rsi,rsi
	mov rsi, result
	mov byte[count], 04
	
label1:	rol ax, 04
	mov bl, al
	and bl, 0fh
	cmp bl, 09h
	jbe l4

	add bl, 07h
l4:	add bl, 30h
	
	mov [rsi], bl
	inc rsi
	dec byte[count]
	jnz label1

	ret


space:
	add al,30h
	mov byte[lenf],al
	mov byte[lenf2],al
	mov byte[lenf3],al
	
	;call HtoA
	print lenf,3
	
	print msg5,len5

	;print buffer,40
	
	xor rsi,rsi

	mov rsi,buffer
	;mov byte[cnt], 30
	
	; ascii of space is 20h
	
	;sub byte[lenf],30h
	
	mov byte[scount],0

loop1:	cmp byte[rsi],20h
	jne label
	
	inc byte[scount]

label:
	inc rsi
	dec byte[lenf]
	jnz loop1

	xor rax,rax
	mov al,byte[scount]
	
	call HtoA
	
	
	ret


newline:
	
	
	xor rsi,rsi

	mov rsi,buffer
	;mov byte[cnt], 30
	
	; ascii of space is 20h
	
	;sub byte[lenf],30h
	
	mov byte[scount],0

loop2:	cmp byte[rsi],0xa
	jne label2
	
	inc byte[scount]

label2:
	inc rsi
	dec byte[lenf2]
	jnz loop2

	xor rax,rax
	mov al,byte[scount]
	
	call HtoA
	
	ret
	

character:
	xor rsi,rsi
	xor bl,bl
	mov bl,byte[searchC]
	mov rsi,buffer
	;mov byte[cnt], 30
	
	; ascii of space is 20h
	
	;sub byte[lenf],30h
	
	mov byte[scount],0

loop3:	cmp byte[rsi],bl
	jne label3
	
	inc byte[scount]

label3:
	inc rsi
	dec byte[lenf3]
	jnz loop3

	xor rax,rax
	mov al,byte[scount]
	
	call HtoA
	
	ret
	













