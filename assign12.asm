section .data

meanmsg: db 10,"CALCULATED MEAN IS:-"
meanmsg_len: equ $-meanmsg
sdmsg: db 10,"CALCULATED STANDARD DEVIATION IS:-"
sdmsg_len: equ $-sdmsg
varmsg: db 10,"CALCULATED VARIANCE IS:-"
varmsg_len: equ $-varmsg
array: dd 102.56,198.21,100.67,230.78,67.93
arraycnt: dw 05
dpoint: db '.'
hdec: dq 100

section .bss

dispbuff: resb 10
resbuff: resb 100
mean: resd 1
variance: resd 1
count: resb 2
count1: resb 2
count2: resb 2

%macro linuxsyscall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro 


section .text
global main
main:

finit
fldz
mov rsi,array
mov byte[count],5

up:
fadd dword[rsi]
add rsi,4
dec byte[count]
jnz up

fidiv word[arraycnt]
fst dword[mean]
linuxsyscall 01,01,meanmsg,meanmsg_len
call dispres

mov rsi,array
mov byte[count],5
fldz

up1:
fldz
fadd dword[rsi]              ;load the number
fsub dword[mean]                    ;st0(1st number)minus mean
fmul st0                            ;square it
fadd                                ;add st1=st0+st1
add rsi,4
dec byte[count]   
jnz up1

fidiv word[arraycnt]
fst dword[variance]
fsqrt
linuxsyscall 01,01,sdmsg,sdmsg_len
call dispres

fld dword[variance]
linuxsyscall 01,01,varmsg,varmsg_len
call dispres

exit:
mov rax,60
mov rdi,0
syscall

disp8_proc:
mov rdi,dispbuff
mov byte[count1],2

back:
rol bl,04
mov dl,bl
and dl,0FH
cmp dl,09
jbe next1
add dl,07H

next1:
add dl,30H
mov byte[rdi],dl
inc rdi
dec byte[count1]
jnz back

dispres:
fimul dword[hdec]
fbstp tword[resbuff]
mov byte[count2],9
mov rsi,resbuff+9

up2:
push rsi
mov bl,byte[rsi]
call disp8_proc

linuxsyscall 01,01,dispbuff,2

pop rsi
dec rsi
dec byte[count2]
jnz up2

linuxsyscall 01,01,dpoint,1
mov bl,byte[resbuff]
call disp8_proc
linuxsyscall 01,01,dispbuff,2
ret