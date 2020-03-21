%macro myprint 1
    mov rdi,formatpf
    sub rsp,8
    movsd xmm0,[ %1 ]
    mov rax,1
    call printf
    add rsp,8
%endmacro

%macro myscan 1
    mov rdi,formatsf
    mov rax,0
    sub rsp,8
    mov rsi,rsp
    call scanf
    mov r8,qword[rsp]
    mov qword[ %1 ],r8
    add rsp,8
%endmacro


section .data




section .bss



section .text

        global _start
        extern scanf
        extern printf


_start:






EXIT:
        mov rax,60
	    mov rdi,00
	    syscall

