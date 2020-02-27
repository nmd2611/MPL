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

title :db "------ Factorial Program ------",0xa
      db "Enter Number : ",0x0A
title_len: equ $-title
msg2 db "Factorial = ", 0xa
len2 equ $-msg2
cnt: db 00H
cnt2:db 02H
num_cnt: db 00H
;--------------- BSS SECTION -------------------------
section .bss
number resb 2
factorial resb 8 
;--------------- TEXT SECTION -------------------------
section .text
global _start

_start:
print title,title_len       ; print
accept number,2              ; accept

mov rsi,number      ;convert no.from ascii to hex
call AtoH   ;converted number is stored in "bl"
mov bl,al 

FACTORIAL:
call fact_proc
mov rbx,rax
mov rdi,factorial
call HtoA_value
print factorial,8

;Exit System call
exit:
mov rax,60
mov rdi,0
syscall
;------------ FACT PROCEDURE ------
fact_proc:
cmp bl,01H
jne do_calc
mov ax,1
ret
do_calc:
push rbx;
dec bl
call fact_proc
pop rbx
mul bl
ret
;------------- ASCII to HEX Conversion Procedure ---------------------
AtoH:       ;result hex no is in bl
mov byte[cnt],02H
mov bx,00H
hup:
rol bl,04
mov al,byte[rsi]
cmp al,39H
JBE HNEXT
SUB al,07H
HNEXT:
sub al,30H
add bl,al
INC rsi
DEC byte[cnt]
JNZ hup
ret
;------HEX TO ASCII CONVERSION METHOD FOR VALUE(2 DIGIT) ----------------
HtoA_value: ;hex_no to be converted is in ebx //result is stored in rdi/user defined variable
mov byte[cnt2],08H
aup1:
rol ebx,04
mov cl,bl
and cl,0FH
CMP CL,09H
jbe ANEXT1
ADD cl,07H
ANEXT1: 
add cl, 30H
mov byte[rdi],cl
INC rdi
dec byte[cnt2]
JNZ aup1
ret
;------------- END PROGRAM -----------------------------
