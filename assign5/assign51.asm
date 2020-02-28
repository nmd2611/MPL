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

extern space 
extern newline
extern character
extern openfile
extern readfile
extern writefile
extern closefile
extern exit
extern HtoA

global lenf
global lenf2
global lenf3
global scount
global fin
global buffer
global cnt
global result
global count

global fname
global msg1
global len1
global msg2
global len2
global msg5
global len5
global msg4
global len4
global msg6
global len6
global buffer2
global len3
global searchC

section .data
	fname db 'sample.txt',0
	
	msg1 db "Inside File",0xa
	len1 equ $-msg1

	msg2 db "File Read successfully",0xa
	len2 equ $-msg2

	msg4 db "Spaces = "
	len4 equ $-msg4
	
	msg6 db "Line = "
	len6 equ $-msg6	

	msg5 db 0xa
	len5 equ $-msg5

	
	buffer2 db "this is the extra text added",0xa
	len3 equ $-buffer2
	
	scount db 0

section .bss
	fin resb 10
	buffer resb 50
	cnt resb 10
	result resb 10
	result2 resb 10
	lenf resb 10
	lenf2 resb 10
	lenf3 resb 10
	count resb 10
	
	searchC resb 10

section .text

global _start

_start:
	
	call openfile
	
	call readfile
	
	call space
	
	print msg4,len4
	print result,4
	print msg5,len5
	
	call newline

	print msg6,len6
	mov byte[result],00
	print result,4
	print msg5,len5
	
	accept searchC,2
	
	call character

	mov byte[result],00
	print result,4
	
	
	call closefile
	

	call exit
	








