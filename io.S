;;;             +------------- MBRLoader 0.1-i386 -----------------+
;;;             | ArnaK, Inc.                                      |
;;;             |                                                  |
;;;             | io.S                                             |
;;;             +--------------------------------------------------+
	
	GET	step2.S

;;; +------------------------------------------------------------------------+
;;; | print                                                                  |
;;; |     entree : ds:[si] = chaine a ecrire                                 |
;;; +------------------------------------------------------------------------+
export	print
print:
	push    ax
	push    bx

	mov     ah,#0xe		;  affichage en mode teletype
	mov     bx,si		;  ds:[si] = message a afficher
print1:
	seg     ds
	.word   0x78a		;  = mov al,[bx]
	cmp     al,#0		;  si caractere de fin de chaine
	jz      print2		;  ->fin
	;;  sinon
	inc     bx		;  adresse du caractere suivant
	push    bx
	mov	bl,#7		; couleur de texte
	mov     bh,#0
	int     0x10		;  afficher le caractere
	pop     bx
	jmp	print1		;  boucle
print2:
	pop     bx
	pop     ax

	ret

;;; +------------------------------------------------------------------------+
;;; | printlist                                                              |
;;; +------------------------------------------------------------------------+
export	printlist
printlist:
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si

	mov	cl,#48
	mov	di,#list
loopprnlist:
	mov	al,[di]
	cmp	al,#0
	jz	printlistok

 	inc	cl
	mov	ah,#0xe
	mov	al,cl
	cmp	al,#58
	jz	abcdef
	jmp	abcdef_
abcdef:
	mov	cl,#97		; 'a'
	mov	al,cl
abcdef_:	
	mov	bl,#7
	int	0x10
	
	mov	ah,#0xe
	mov	al,#32		; 
	int	0x10		; 
	mov	al,#45		; ' - '
	int	0x10		; 
	mov	al,#32		; 
	int	0x10		; 
	
	add	di,#2
	mov	al,[di]
	sub	di,#2
	call	findos
	call	print
	
	mov	si,#disk_msg
	call	print
	mov	ah,#0xe
	mov	al,[di]
	sub	al,#0x80
	add	al,#48
	mov	bl,#7
	int	0x10

	inc	di
	mov	si,#part_msg
	call	print
	mov	ah,#0xe
	mov	al,[di]
	add	al,#48
	mov	bl,#7
	int	0x10
	add	di,#2
	
	mov	al,#41		; ')'
	int	0x10		; 
	
	mov	al,#10
	int	0x10
	mov	al,#13
	int	0x10

	jmp	loopprnlist
	
printlistok:
	cmp	cl,#48
	jz	emptylist
	jmp	endprnlst

emptylist:
	mov	si,#empty_msg
	call	print
	
endprnlst:
	pop	si
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax

	ret

;;; +------------------------------------------------------------------------+
;;; | inputchar                                                              |
;;; |        retour : al = ascii, ah = scancode                              |
;;; +------------------------------------------------------------------------+
export	inputchar
inputchar:
	push	bx
	push	si

	mov	ah,#0
	int	0x16

	push	ax
	
	mov	ah,#0xe
	mov	bl,#7
	mov	bh,#0
	int	0x10
	mov	al,#10
	int	0x10
	mov	al,#13
	int	0x10

	pop	ax

	pop	si
	pop	bx

	ret
	

;;; +------------------------------------------------------------------------+
;;; | Messages                                                               |
;;; +------------------------------------------------------------------------+
disk_msg:
	.ascii	" (disque 0x8"
	.byte	0
part_msg:
	.ascii	", partition no"
	.byte	0
empty_msg:
	.ascii	"Aucune partition demarrable."
	.byte	0
	
export	prompt_
prompt_:
	.ascii	"Votre choix : "
	.byte	0
	
export	invalid
invalid:
	.ascii	"Saisie invalide !"
	.byte	10,10,13,0
