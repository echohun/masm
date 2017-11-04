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
big3:	mov dl,bl
	mov ah,02h
	int 21h
