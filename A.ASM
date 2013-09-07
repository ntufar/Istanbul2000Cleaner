code	segment	public
	assume cs:code
	org 100h
begin:
	jmp inst
body:
	nop			;not to be the same with viri
	cmp ax,4624h
	jne runreal
	mov ax,3434h
	iret
	
runreal:
	db	0eah	;jmp
i21off	dw	?
i21seg	dw 	?

inst:
	call zap
	mov ax,3521h
	int 21h
	mov cs:i21off,bx
	mov ax,es
	mov cs:i21seg,ax
	push cs
	pop ds
	lea dx,body
	mov ax,2521h
	int 21h
	
	lea dx,inst
	int 27h
	
zap	proc	near
;......... exist? .........
	xor ax,ax
	mov es,ax
	mov bp,es:21h*4
	mov es,es:21h*4+2
	push es
	mov ax,es:[bp]
	cmp ax,243dh
	jne absent;
	mov ax,es:[bp+2]
	cmp ax,7546h
	jne absent;	
	mov ax,es:[bp+4]
	cmp al,04h
	jne absent;	
;............................
	mov ax,3521h
	int 21h
	mov ax,es
	xor dx,dx
	mov es,dx
	cli
	mov es:4*21h,bx		;offset
	mov es:4*21h+2,ax	;segment
	sti
;...... free HIS block ......
	mov ax,4900h
	pop es
	int 21h
;.......................
	ret
absent:	
	push cs
	pop ds
	lea dx,prmpt
	mov ax,0900h
	int 21h
	int 20h
prmpt	db 'Virus not found',0ah,0dh,'$'
zap	endp

code	ends
	end	begin