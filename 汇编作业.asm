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

LL: lea     dx,string1
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

L1: 	
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
bian:	cmp [si],61h
	jae hey1
	jmp hey2
	hey1:
	cmp [si],7Ah
	ja hey2
	sub [si],20h
	hey2:
	cmp [si],24h
	jz output
	inc si
	loop bian

output:	lea  dx,savestr
	mov  AH,09H
	int  21H
	jmp  L6
L2: 
	call clearline
	lea  dx,string02
	mov  AH,09H
	int  21H
	
	call clearline
	
	lea si,savestr

	
Linput2:	mov ah,01h
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
	
big:    cmp [si],bl
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
	int 21h
	
	
	jmp  L6
L3: 
	call clearline
	lea  dx,string03
	mov  AH,09H
	int  21H
	
	call clearline
	
	lea dx,save3
	mov ah,0ah
	int 21h

     CALL clearline


     LEA BX,save3
     LEA SI,savestr

  L32:

       MOV AL,[SI]
       MOV CL,0AH
       MUL CL
       MOV [SI],AL
       SUB [BX],30H
       MOV AL,[BX]
       ADD [SI],AL
       CMP [BX+1],0DH
       JZ L33
       CMP [BX+1],20H
       JZ L33
       ADD BX,01H
       JMP L32
  L33:
       CMP [BX+1],0DH
       JZ L340 ;
       ADD SI,01H
       ADD BX,02H
       JMP L32
       
  L340:
       MOV [SI+1],'$'
       
       LEA AX,savestr;
       SUB SI,AX
       ADD SI,01H
       MOV CX,SI
  L341:     
       LEA SI,savestr
  L34:              
       CMP [SI+1],'$'
       JZ L36
       MOV AH,[SI]
       CMP AH,[SI+1]
       JNC L35
       ADD SI,01H
       JMP L34
  L35:             
       XCHG AH,[SI+1]
       MOV [SI],AH
       ADD SI,01H
       JMP L34
  L36:                 
       LOOP L341

       LEA DI,save3
       LEA SI,savestr
  L360:
       CMP [SI],'$'
       JZ L37
       MOV BL,10H
       MOV AH,00H
       MOV AL,[SI]
       DIV BL
       
      
       CMP AL,0AH
       JC L361
       ADD AL,37H
       JMP L362
  L361:
       ADD AL,30H
       JMP L362
       
  L362:     
       CMP AH,0AH
       JC L363
       ADD AH,37H
       JMP L364
  L363:
       ADD AH,30H
       JMP L364
       
       
  L364:     
       MOV [DI],AL
       MOV [DI+1],AH
       MOV [DI+2],48H
       MOV [DI+3],20H
       ADD DI,04H
       ADD SI,01H
       JMP L360
  L37:    
       MOV [DI],'$'
       MOV AH,09H
       LEA DX,save3
       INT 21H
       JMP L6


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
hour1:	
	mov [si],32h
	add cl,1Ch
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

display2:
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
display3:
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
jmp starttime

	jmp  L6
L5: 	
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

