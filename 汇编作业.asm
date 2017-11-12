	TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

; TODO: add your data here!!!!

string1 db "Please input 1-5 $"
string01 db "This is function 1 $"
string02 db "This is function 2 $"
string03 db "This is function 3 $"
string04 db "This is function 4 $"
string05 db "This is function 5 $"
;str01 db "Input string:"
savestr db 100 dup (?)
output2 db "The maximum is: $"
save3 db 100 dup('$')
flag1 db 0
save4 db 100 dup('$')
DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX


; TODO: add your code here!!!!

LL: lea     dx,string1		;外层start部分
    MOV     AH,09H
    INT     21H

call clearline

    MOV     AH,01H
    INT     21H
    CMP   al,31h
    jz    L1
    CMP   al,32h
    jz    L2
    CMP   al,33h
    jnz    s3
    jmp   L3
s3: CMP   al,34h
    jnz    s4
    jmp   L4
s4: CMP   al,35h
    jnz    s5
    jmp   L5
s5: jmp   L6
				;上面外层start部分
L1: 				;程序1
	call clearline
	lea  dx,string01
	mov  AH,09H
	int  21H
	
	call clearline
	
	lea si,savestr

	
Linput:	mov ah,01h
	int 21h
	cmp al,0dh
	jz link
	mov [si],al
	inc si
	jmp Linput
	
link:	
	call clearline
	mov [si],'$'
	
	lea si,savestr
bian:	cmp [si],61h		;判断是否为小写
	jae hey1
	jmp hey2
	hey1:
	cmp [si],7Ah		
	ja hey2
	sub [si],20h		;小写转大写
	hey2:
	cmp [si],24h
	jz output
	inc si
	loop bian

output:	lea  dx,savestr		;输出结果
	mov  AH,09H
	int  21H
	jmp  L6
L2: 				;程序2
	call clearline
	lea  dx,string02
	mov  AH,09H
	int  21H
	
	call clearline
	
	lea si,savestr

	
Linput2:	mov ah,01h	;输入
	int 21h
	cmp al,0dh
	jz link2
	mov [si],al
	inc si
	jmp Linput2
	
link2:	
	call clearline
	mov [si],'$'
	
	lea si,savestr	
	mov bl,0
	
big:    cmp [si],bl		;这三个big循环判断最大值
	jb big2
	mov bl,[si]

big2:	cmp [si],24h
	jz big3
	inc si
	loop big
big3:	
	lea    dx,output2
   	MOV    AH,09H
   	INT    21H
	mov dl,bl
	mov ah,02h
	int 21h			;输出最大值
	
	
	jmp  L6
L3:				;程序3
     call clearline
     lea  dx,string03
	mov  ah,09h
	int  21h
	call clearline
LL0:
     
     mov ah,01h
     lea bx,save3
  LL1:  
       int 21h
       mov [bx],al
       add bx,01h
       cmp al,0dh
       loopnz LL1

     lea bx,save3
     lea si,savestr
  LL2:			;十进制转16进制

       mov al,[si]
       mov cl,0ah
       mul cl
       mov [si],al
       sub [bx],30h
       mov al,[bx]
       add [si],al
       cmp [bx+1],0dh
       jz LL3
       cmp [bx+1],20h
       jz LL3
       add bx,01h
       jmp LL2
  LL3:
       cmp [bx+1],0dh
       jz tentosix0 		;输入结束
       add si,01h
       add bx,02h
       jmp LL2
       
  tentosix0:
       mov [si+1],'$'
       
       lea ax,savestr
       sub si,ax
       add si,01h
       mov cx,si
  tentosix1:     
       lea si,savestr
  tentosix:        
       cmp [si+1],'$'
       jz tostr
       mov ah,[si]
       cmp ah,[si+1]
       jnc LL4
       add si,01h
       jmp tentosix
  LL4:         		;比较
       xchg ah,[si+1]
       mov [si],ah
       add si,01h
       jmp tentosix
  tostr:       
       loop tentosix1

       lea di,save3
       lea si,savestr
  tostr0:
       cmp [si],'$'
       jz output3
       mov bl,10h
       mov ah,00h
       mov al,[si]
       div bl
       
      
       cmp al,0ah
       jc tostr1
       add al,37h
       jmp tostr2
  tostr1:
       add al,30h
       jmp tostr2
       
  tostr2:     
       cmp ah,0ah
       jc tostr3
       add ah,37h
       jmp tostr4
  tostr3:
       add ah,30h
       jmp tostr4
       
       
  tostr4:     		;每个数格式矫正填补到四位
       mov [di],al
       mov [di+1],ah
       mov [di+2],48h
       mov [di+3],20h
       add di,04h
       add si,01h
       jmp tostr0
  output3:    			;输出
       mov [di],'$'
       call clearline
       mov ah,09h
       lea dx,save3
       int 21h
       jmp L6

L4: 
	call clearline
	lea  dx,string04
	mov  AH,09H
	int  21H
	call clearline
	starttime:
	mov al,00h
	mov ah,00h
	int 1ah
;cx中是小时
;dx中是分钟和秒  3600到65536的转换
display1:
	lea si,save4
	cmp cl,19
	ja hour1
	cmp cl,9h
	ja hour2
	jmp hour3
hour1:				;对小时处理
	mov [si],32h
	add cl,1ch
	jmp hour4
hour2:
	mov [si],31h
	add cl,26h
	jmp hour4
hour3:
	mov [si],30h
	add cl,30h
hour4:
	inc si
	mov [si],cl
	inc si
	mov [si],3ah
	inc si

display2:		;对分钟处理
	mov al,00h
	mov ah,00h
	int 1ah
	mov ax,dx
	mov dx,0
	mov bx,18	;除以进制
	div bx
	mov bl,60
	div bl
	mov flag1,ah	;保存秒
	mov ah,0
	mov bl,10
	div bl
	mov [si],al
	add [si],30h	;保存十位
	inc si
	mov [si],ah
	add [si],30h	;保存个位
	inc si
	mov [si],3ah
	inc si
display3:		;对秒处理
	mov ah,0
	mov al,flag1
	mov bl,10
	div bl
	mov [si],al
	add [si],30h	;保存十位
	inc si
	mov [si],ah
	add [si],30h	;保存个位
	

	
	lea dx,save4
	mov ah,09h
	int 21h

	mov ah,3	;重置光标
	int 10h
	sub dl,8
	mov ah,2
	int 10h
jmp starttime		;循环显示时间

	jmp  L6
L5: 			;程序5，结束进程
	MOV  AX, 4C00H
	INT  21H
	jmp  L6
L6:
	call clearline
	mov ah,4ch
	JMP LL
    



; return to operating system:
    RET
START   ENDP

clearline proc
mov dl,0ah
mov ah,02h
int 21h
mov dl,0dh
mov ah,02h
int 21h
ret
clearline endp


;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

