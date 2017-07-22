;;;             +------------- MBRLoader 0.1-i386 -----------------+
;;;             | ArnaK, Inc.                                      |
;;;             |                                                  |
;;;             | list.S                                           |
;;;             +--------------------------------------------------+
	
	GET	step2.S

;;; +-------------------------------------------------------------------------+
;;; | makelist                                                                |
;;; +-------------------------------------------------------------------------+
export	makelist
makelist:
	push	di
	push	ax
	push	cx
	push	dx

	mov	dl,#0x80	; 
	mov	dh,#1		; 1e disque, 1e part.
	mov	di,#list	; debut de liste
	
nextentry:
			
	mov	ah,#8
	push	dx
	int	0x13
	jc	_done

	pop	dx
	
	call	gettype
	cmp	al,#0
	jnz	putinlist
	jmp	continue
	
putinlist:
	
	mov	[di],dl
	inc	di
	mov	[di],dh
	inc	di
	mov	[di],al
	inc	di
continue:
	
	inc	dh
	cmp	dh,#5
	jz	nextdisk
	jmp	nextentry

nextdisk:

	mov	dh,#1
	inc	dl
	cmp	dl,#0x84
	jnz	nextentry

	jmp	done

_done:	
	pop	dx
done:
	
	pop	dx
	pop	cx
	pop	ax
	pop	di

	ret
	

;;; +-------------------------------------------------------------------------+
;;; | Donnees                                                                 |
;;; +-------------------------------------------------------------------------+
	
	;; ** buffer pour la liste :
	;;             17 entrees max
	;;             la derniere indique tjs la fin
	;;             format d'une entree :
	;;                    disque BYTE
	;;                    part BYTE
	;;                    type de la part. BYTE
	;; Au total : 25 WORDS + 1 BYTE
export	list
list:
	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte	0
