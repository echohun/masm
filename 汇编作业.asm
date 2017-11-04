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
str01 db "Input string:"
savestr db 100 dup (?)
output2 db "The maximum is: $"

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
	
	lea si,savestr

	mov cx,0
Linput3:	
	mov ah,01h
	int 21h
	cmp al,0dh
	jz link3
	mov [si],al
	inc si
	inc cx
	jmp Linput3
	
link3:	
	call clearline
	mov [si],'$'
	dec cx
	
	lea si,savestr
	add si,cx
LP1:
	push cx
	push si
LP2:
	mov al,[si]
	cmp al,[si-1]
	jae NOXCHG
	xchg al,[si-1]
	mov [si],al
NOXCHG:
	dec si
	loop LP2
	pop si
	pop cx
	loop LP1

	lea  dx,savestr
	mov  AH,09H
	int  21H

	
	jmp  L6
L4: 
	lea  dx,string04
	mov  AH,09H
	int  21H
;input your function here
	jmp  L6
L5: 
	lea  dx,string05
	mov  AH,09H
	int  21H
;input your function here
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

