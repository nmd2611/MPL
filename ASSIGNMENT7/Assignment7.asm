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
fname db 'sorting.txt',0

msghead db "*************BUBBLE SORT****************",0xA
msghead_len equ $-msghead

msgerr db "Error in Opening the File",0xA
msgerr_len equ $-msgerr

msgsuc db "File Opened Successfully !!!",0xA
msgsuc_len equ $-msgsuc

msgsort db "After Sorting",0xA
msgsort_len equ $-msgsort



section .bss

count1 resb 8
count2 resb 8
buffer resb 200
fd_in resb 8
bufferlen resb 8
buffercpy resb 200

section .text

global _start

_start:

print msghead,msghead_len

mov rax,2		;syscall for file opening
mov rdi,fname
mov rsi,2
mov rdx,0777
syscall

mov [fd_in],rax
bt rax,63
jc ERROR
print msgsuc,msgsuc_len
jmp next1

ERROR:
print msgerr,msgerr_len
jmp EXIT

next1:
mov rax,0		;syscall for reading from a file
mov rdi,[fd_in]
mov rsi,buffer
mov rdx,200
syscall


mov [bufferlen],rax
mov [count1],rax
mov [count2],rax

print buffer,[count2]


BUBBLE:

mov al,byte[count2]
mov byte[count1],al
dec byte[count1]	;total passes=total count - 1

mov rsi,buffer    ;0th byte
mov rdi,buffer+1  ;1st byte

looplabel:
	

mov bl,byte[rsi]
mov cl,byte[rdi]

cmp bl,cl
ja SWAP
inc rsi
inc rdi
dec byte[count1]
jnz looplabel
dec byte[bufferlen]
jnz BUBBLE
jmp END

SWAP:

mov byte[rsi],cl
mov byte[rdi],bl
inc rsi
inc rdi
dec byte[count1]
jnz looplabel
dec byte[bufferlen]
jnz BUBBLE
jmp END


END:

print msgsort,msgsort_len 
print buffer,[count2]

mov rax,1
mov rdi,[fd_in]
mov rsi,msgsort
mov rdx,msgsort_len
syscall

mov rax,1
mov rdi,[fd_in]
mov rsi,buffer
mov rdx,[count2]
syscall


mov rax,3
mov rdi,[fd_in]
syscall

EXIT:

	mov rax,60
	mov rdi,0
	syscall





















































