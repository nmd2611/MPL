 extern scanf
 extern printf


%macro myprintf 1
    mov rdi,formatpf
    sub rsp,8
    movsd xmm0,[ %1 ]
    mov rax,1
    call printf
    add rsp,8
%endmacro

%macro myscanf 1
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

    ff1 db "%lf +i %lf",10,0
    ff2 db "%lf -i %lf",10,0

    formatpi db "%d",10,0
    formatpf db "%lf",10,0
    formatsf db "%lf",0

    four dq 4
    two dq 2



section .bss

    a resq 1
    b resq 1
    c resq 1

    x1 resq 1
    x2 resq 1

    b2 resq 1

    delta resq 1

    fac resq 2   ; store value of 4ac

    ta resq 2    ; store 2a

    ; for imaginary roots
    realp resq 2
    imagp resq 2



section .text

        global main
       


main:

    ; accept a,b,c from user

        myscanf a
        myscanf b
        myscanf c

    ; calculate b^2

        finit
        fldz
        fld qword[b]
        fmul qword[b]
        fstp qword[b2]

        ;myprintf b2        ; working

        ; calculate 4ac
        fild qword[four]
        fmul qword[a]
        fmul qword[c]
        fstp qword[fac]

        ; myprintf fac      ; working

        ; calculate delta = b2 - 4ac
        fld qword[b2]
        fsub qword[fac]
        fstp qword[delta]

        ; myprintf delta    ; working

        ; calculate 2a
        fild qword[two]
        fmul qword[a]
        fstp qword[ta]

        ; myprintf ta       ; working

        btr qword[delta],63     ; bit test 
        jc imaginary    ; jump to imaginary roots part

; ----------- REAL ROOTS ------------

        ; proceed with normal calculations
        fld qword[delta]
        fsqrt
        fstp qword[delta]   ; after this operation, delta now stores its sqrt

        ; myprintf delta    ; working

        ; now reset the stack = 0
        fldz
        fsub qword[b]   ; value of -b

        ; calculate x1
        fadd qword[delta]
        fdiv qword[ta]
        fstp qword[x1]

        myprintf x1     ; real root1

         ; now reset the stack = 0
        fldz
        fsub qword[b]   ; value of -b

        ; calculate x2
        fsub qword[delta]
        fdiv qword[ta]
        fstp qword[x2]

        myprintf x2     ; real root 2

        jmp EXIT

; ---------- IMAGINARY ROOTS ----------

imaginary:

        fld qword[delta]
        fsqrt
        fstp qword[delta]   ; replace value of delta with its sqrt

        fldz

        ; calculate real part
        fsub qword[b]
        fdiv qword[ta]
        fstp qword[realp]

        ;myprintf realp     ; working

        ; calculate imaginary part
        fld qword[delta]
        fdiv qword[ta]
        fstp qword[imagp]

        ;myprintf imagp     ; working


        ;--------------printing img root1
        mov rdi,ff1
        sub rsp,8
        movsd xmm0,[realp]
        movsd xmm1,[imagp]
        mov rax,2
        call printf
        add rsp,8

        mov rdi,ff2
        sub rsp,8
        movsd xmm0,[realp]
        movsd xmm1,[imagp]
        mov rax,2
        call printf
        add rsp,8


EXIT:
        mov rax,60
	    mov rdi,00
	    syscall


; ---------- PROCEDURES  ------------

