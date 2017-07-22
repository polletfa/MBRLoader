;;;             +------------- MBRLoader 0.1-i386 -----------------+
;;;             | ArnaK, Inc.                                      |
;;;             |                                                  |
;;;             | bootsect.S                                       |
;;;             +--------------------------------------------------+
			
.globl _main

;;; +-----------------------------------------------------------------------+
;;; | Symbole main : symbole principal                                      |
;;; +-----------------------------------------------------------------------+
_main:

	mov	ax,#0x07c0	; On fixe l'ES a 0x7c0 car c'est la que le
	mov	es,ax		; programme a ete charge par le BIOS
	mov	ds,ax		; idem pour DS

	;;  charger les secteurs 2-7 du disque 0x80
	jmp	load

;;; +-------------------------------------------------------------------------+
;;; | _diskerr : appele en cas d'erreur d'acces au disque                     |
;;; +-------------------------------------------------------------------------+
_diskerr:
	mov	ax,#0x7c0
	mov	es,ax
	mov	ds,ax

	mov	si,#demsg
	call	print
	cli			; desactiver les interruptions
	hlt			; 'endormir' le processeur

;;; +-------------------------------------------------------------------------+
;;; | load                                                                    |
;;; +-------------------------------------------------------------------------+
load:
	;; initialiser
	mov	ah,#0
	mov	dl,#0x80
	int	0x13
	
	;; on charge les secteurs 2-7 a 0x50:0
	mov	dl,#0x80
	mov	dh,#0
	mov	cx,#2
	mov	ax,#0x50
	mov	es,ax
	mov	ds,ax
	mov	ah,#2
	mov	al,#6
	mov	bx,#0

	int	0x13
	jc	_diskerr

	;; chargeur charge :)

	.byte	0xea		; 
	.word	0		; = jmp 0050:0000
	.word	0x50		;

	;; *** chargeur charge et lance


;;; +-------------------------------------------------------------------------+
;;; | print                                                                   |
;;; |     entree : ds:	[si]                                                  |
;;; +-------------------------------------------------------------------------+
print:
	push	ax
	push	bx

	mov	ah,#0xe		; affichage en mode teletype
	mov	bx,si		; ds:[si] = message a afficher
print1:
	seg	ds
	.word	0x78a		; = mov al,[bx]
	cmp	al,#0		; si caractere de fin de chaine
	jz	print2		; ->fin
	;; sinon
	inc	bx		; adresse du caractere suivant
	push	bx
	mov	bl,#1		; couleur de texte
	int	0x10		; afficher le caractere
	pop	bx
	jmp	print1		; boucle
print2:

	pop	bx
	pop	ax
	
	ret


;;; +-------------------------------------------------------------------------+
;;; | Donnees                                                                 |
;;; +-------------------------------------------------------------------------+

demsg:
	.ascii	"MBRLoader 0.1-i386"
	.byte	10,13
	.ascii	"ArnaK, Inc."
	.byte	10,10,13
	.ascii	"** ERREUR **"
	.byte	10,13
	.ascii	"Erreur d'acces au disque 0x80."
	.byte	10,13,0

_end:		

end
