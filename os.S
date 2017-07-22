;;;             +------------- MBRLoader 0.1-i386 -----------------+
;;;             | ArnaK, Inc.                                      |
;;;             |                                                  |
;;;             | os.S                                             |
;;;             +--------------------------------------------------+
	
	GET	step2.S

;;; +-------------------------------------------------------------------------+
;;; | oslist : liste des types de partitions                                  |
;;; +-------------------------------------------------------------------------+
oslist:
	.byte	0x1
	.ascii	"FAT12"
	.byte	0,0x2
	.ascii	"XENIX root"
	.byte	0,0x3
	.ascii	"XENIX usr"
	.byte	0,0x4
	.ascii	"FAT16 <32M"
	.byte	0,0x5
	.ascii	"Extended"
	.byte	0,0x6
	.ascii	"FAT16"
	.byte	0,0x7
	.ascii	"HPFS/NTFS"
	.byte	0,0x8
	.ascii	"AIX"
	.byte	0,0x9
	.ascii	"AIX bootable"
	.byte	0,0xa
	.ascii	"OS/2 Boot Manager"
	.byte	0,0xb
	.ascii	"Win95 FAT32"
	.byte	0,0xc
	.ascii	"Win95 FAT32 (LBA)"
	.byte	0,0xe
	.ascii	"Win95 FAT16 (LBA)"
	.byte	0,0xf
	.ascii	"Win95 Ext'd (LBA)"
	.byte	0,0x10
	.ascii	"OPUS"
	.byte	0,0x11
	.ascii	"Hidden FAT12"
	.byte	0,0x12
	.ascii	"Compaq"
	.byte	0,0x14
	.ascii	"Hidden FAT16 <32M"
	.byte	0,0x16
	.ascii	"Hidden FAT16"
	.byte	0,0x17
	.ascii	"Hidden HPFS/NTFS"
	.byte	0,0x18
	.ascii	"AST Windows swap"
	.byte	0,0x1b
	.ascii	"Hidden Win95"
	.byte	0,0x1c
	.ascii	"Hidden Win95"
	.byte	0,0x1e
	.ascii	"Hidden Win95"
	.byte	0,0x24
	.ascii	"NEC DOS"
	.byte	0,0x3c
	.ascii	"PartitionMagic"
	.byte	0,0x40
	.ascii	"Venix 80286"
	.byte	0,0x41
	.ascii	"PPC PReP Boot"
	.byte	0,0x42
	.ascii	"SFS"
	.byte	0,0x4d
	.ascii	"QNX4.x"
	.byte	0,0x4e
	.ascii	"QNX4.x 2nd partition"
	.byte	0,0x4f
	.ascii	"QNX4.x 3rd partition"
	.byte	0,0x50
	.ascii	"OnTrack DM"
	.byte	0,0x51
	.ascii	"OnTrack DM6 Aux."
	.byte	0,0x52
	.ascii	"CP/M"
	.byte	0,0x53
	.ascii	"OnTrack DM6 Aux."
	.byte	0,0x54
	.ascii	"OnTrackDM6"
	.byte	0,0x55
	.ascii	"EZ-Drive"
	.byte	0,0x56
	.ascii	"Golden Bow"
	.byte	0,0x5c
	.ascii	"Priam Edisk"
	.byte	0,0x61
	.ascii	"SpeedStor"
	.byte	0,0x63
	.ascii	"GNU HURD or SysV386"
	.byte	0,0x64
	.ascii	"Novell Netware 286"
	.byte	0,0x65
	.ascii	"Novell Netware 3.11"
	.byte	0,0x67
	.ascii	"Novell"
	.byte	0,0x68
	.ascii	"Novell"
	.byte	0,0x69
	.ascii	"Novell"
	.byte	0,0x70
	.ascii	"DiskSecure Multi-Boot"
	.byte	0,0x75
	.ascii	"PC/IX"
	.byte	0,0x80
	.ascii	"Old Minix"
	.byte	0,0x81
	.ascii	"Minix / old Linux"
	.byte	0,0x82
	.ascii	"Linux swap"
	.byte	0,0x83
	.ascii	"Linux"
	.byte	0,0x84
	.ascii	"OS/2 hidden C:"
	.byte	0,0x85
	.ascii	"Linux extended"
	.byte	0,0x86
	.ascii	"NTFS"
	.byte	0,0x87
	.ascii	"NTFS"
	.byte	0,0x93
	.ascii	"Amoeba"
	.byte	0,0x94
	.ascii	"Amoeba BBT"
	.byte	0,0xa0
	.ascii	"IBM Thinkpad"
	.byte	0,0xa5
	.ascii	"BSD/386"
	.byte	0,0xa6
	.ascii	"OpenBSD"
	.byte	0,0xa7
	.ascii	"NeXTSTEP"
	.byte	0,0xb7
	.ascii	"BSDI"
	.byte	0,0xb8
	.ascii	"BSDI swap"
	.byte	0,0xc1
	.ascii	"DRDOS"
	.byte	0,0xc4
	.ascii	"DRDOS"
	.byte	0,0xc6
	.ascii	"DRDOS"
	.byte	0,0xc7
	.ascii	"Syrinx"
	.byte	0,0xd5
	.ascii	"NTDIOS"
	.byte	0,0xd8
	.ascii	"CP/M-86"
	.byte	0,0xdb
	.ascii	"CP/M / CTOS"
	.byte	0,0xe1
	.ascii	"CP/M / CTOS"
	.byte	0,0xe3
	.ascii	"DOS R/O"
	.byte	0,0xe4
	.ascii	"SpeedStor"
	.byte	0,0xeb
	.ascii	"BeOS"
	.byte	0,0xf1
	.ascii	"Storage Dimensions"
	.byte	0,0xf2
	.ascii	"DOS secondary"
	.byte	0,0xf4
	.ascii	"Storage Dimensions"
	.byte	0,0xfd
	.ascii	"Linux raid auto"
	.byte	0,0xfe
	.ascii	"LANstep"
	.byte	0,0xff
	.ascii	"BBT"
	.byte	0,0
endlistos:
	.ascii	"Systeme inconnu"
	.byte	0

;;; +-------------------------------------------------------------------------+
;;; | findos                                                                  |
;;; |     entree : al=numero de la partition                                  |
;;; |     retour : ds:[si] : nom du systeme                                   |
;;; +-------------------------------------------------------------------------+
export	findos
findos:
	push	ax
	push	cx

	mov	si,#oslist
	
isthisos:
	mov	cl,[si]
	cmp	cl,al
	jz	osfound		; trouve
	cmp	cl,#0
	jz	osfound		; liste parcourue, syst. non trouve.
	;; retourne "Systeme inconnu"
	
	;; passer a l'OS suivant
getnextos:
	inc	si	
	mov	cl,[si]
	cmp	cl,#0
	jnz	getnextos

	inc	si
	jmp	isthisos	; tester cet OS
	

osfound:

	inc	si
	
	pop	cx
	pop	ax

	ret
