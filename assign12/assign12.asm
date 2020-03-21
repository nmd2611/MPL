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

    msg1 db "MEAN :  "
    len1 equ $-msg1

    msg2 db "VARIANCE :  "
    len2 equ $-msg2

    msg3 db "S.D :  "
    len3 equ $-msg3

    msg4 db 0xa
    len4 equ $-msg4

    point db "."


    array dd 1.00,2.00,3.00,4.00,5.00
    arrcnt dw 5

    hdec dq 100

section .bss

    count resb 10

    cnt1 resb 2
    cnt2 resb 2
    

    MEAN resd 2
    VAR resd 2
    SD resd 2

    resbuff resb 100
    dispbuff resb 10


section .text

global _start

_start:

         FINIT
         FLDZ 

         mov rsi, array
         mov byte[count], 5

         

UPP:     FADD dword[rsi]
         add rsi, 4
         dec byte[count]
         jnz UPP

         FIDIV word[arrcnt]
         FST dword[MEAN]

         print msg1,len1

         call dispres

        print msg4,len4


; ------------------ VARIANCE --------------

        FLDZ

        xor rsi,rsi
        mov rsi,array

        mov byte[count],5

 UPP2:  
         FLDZ
        FADD dword[rsi]
        FSUB dword[MEAN]
        FMUL ST0
        FADD
        add rsi, 4
        dec byte[count]
        jnz UPP2

        FIDIV word[arrcnt]
        FST dword[VAR]

        print msg2,len2

        call dispres

        print msg4,len4         ; printing space

; ------------------ STANDARD DEVIATION --------------

        FLDZ

        FLD dword[VAR]
        FSQRT

        FST dword[SD]

        print msg3,len3

        call dispres

EXIT :
         mov rax,60
	     mov rdi,00
	     syscall


; ---------- PROCEDURES  ------------

HtoA:
        
        mov rsi, dispbuff
        mov byte[count], 02
        
label1:	rol al, 04
        mov bl, al
        and bl, 0fh
        cmp bl, 09h
        jbe l4

        add bl, 07h
l4:	    add bl, 30h
        
        mov [rsi], bl
        inc rsi
        dec byte[count]
        jnz label1

        
        ret

; ----------------------------

dispres:

        fimul dword[hdec]
        fbstp tword[resbuff]
        mov byte[cnt2], 9
        mov rsi, resbuff+9

UP2:
        push rsi
        mov al, byte[rsi]

        call HtoA

        print dispbuff,2

        pop rsi
        dec rsi
        dec byte[cnt2]
        jnz UP2

        print point,1
        mov al, byte[resbuff]
        call HtoA
        print dispbuff,2
        ret
