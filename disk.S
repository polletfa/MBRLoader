;;;             +------------- MBRLoader 0.1-i386 -----------------+
;;;             | ArnaK, Inc.                                      |
;;;             |                                                  |
;;;             | disk.S                                           |
;;;             +--------------------------------------------------+
	 
	GET	step2.S

;;; +-------------------------------------------------------------------------+
;;; | disk_read                                                               |
;;; |       entree : dl = disque                                              |
;;; |                dh = plateau                                             |
;;; |                cx = cyl et sect                                         |
;;; |                es:[di] = buffer                                         |
;;; +-------------------------------------------------------------------------+
export	disk_read
disk_read:

	push	ax
	
	;; plateau...ok (dh)
	;; cyl...ok (cx)
	;; sect...ok (cx)
	
	;; nb sect...
	mov	al,#1

	;; fonction
	mov	ah,#2

	;; buffer..ok (es:[di])

	;; int =>
	int	0x13

	pop	ax

	ret

;;; +-------------------------------------------------------------------------+
;;; | gettype                                                                 |
;;; |     entree : dl = disque                                                |
;;; |              dh = part                                                  |
;;; |     retour : al = type                                                  |
;;; +-------------------------------------------------------------------------+
export	gettype
gettype:
	push	cx
	push	ax
	push	di
	push	es
	push	dx
	
	;; charger le MBR
	call	loadMBR
		
	;; on se deplace 0x10 octets avant l'entree correspondant a la 1e part
	add	di,#0x1ae

	;; on se deplace a la bonne entree
	pop	dx
	mov	ch,#0
	mov	cl,dh

nextpart:
	add	di,#0x10
	loop	nextpart

	;; on se deplace au parametre 'type'
	add	di,#4

	seg	es
	mov	cl,[di]

	pop	es
	pop	di
	pop	ax

	mov	al,cl

	pop	cx

	ret
	
;;; +-------------------------------------------------------------------------+
;;; | loadMBR                                                                 |
;;; |     entree : dl = disque                                                |
;;; |     retour : es:[di] = buffer                                           |
;;; +-------------------------------------------------------------------------+
export	loadMBR
loadMBR:
	push	ax
	push	cx
	push	dx
	
	mov     dh,#0		; plateau
	mov     cx,#1		; cyl et sect
	mov     di,#0		; offset du buffer

	push    ax
	mov     ax,#0x2000
	mov     es,ax
	pop     ax

	call    disk_read

	pop	dx
	pop	cx
	pop	ax

	ret
