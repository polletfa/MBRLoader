# +-  Programme  -----------------------------------------------------------+
# | MBRLoader 2.0-i386                                                      |
# | Gestionnnaire de démarrage "multi-boot"                                 |
# |                                                                         |
# | Voyez la documentation ci-jointe                                        |
# |                                                                         |
# +-  Contacts  ------------------------------------------------------------+
# | http://mbrloader.arnak.cjb.net                                          |
# | mailto:mbrloader@arnak.cjb.net                                          |
# |                                                                         |
# +-  Auteur  --------------------------------------------------------------+
# | ArnaK, SARL / Rip-off, Inc. / Kompanio Fraudo / Schwindel, GmbH         |
# | Fabien Pollet                                                           |
# | http://www.arnak.cjb.net                                                |
# | mailto:arnak@arnak.cjb.net                                              |
# |                                                                         |
# +-  Fichier  -------------------------------------------------------------+
# | Makefile                                                                |
# | Fichier Makefile                                                        |
# +-------------------------------------------------------------------------+

# +-------------------------------------------------------------------------+
# | Variables                                                               |
# +-------------------------------------------------------------------------+

include Makefile.devicefiles

CC = gcc
CFLAGS = -c
INSTALLERFLAGS = -DHARDDISK=$(HARDDISK) -DFLOPPYDISK=$(FLOPPYDISK)
LD = gcc
LDFLAGS = 

OBJS_INSTALLER = installer.o
SRCS_STEP1 = bootsect.qas
SRCS_STEP2 = main.qas interf.qas string.qas config.qas configi.qas os.qas disk.qas fs.qas multil.qas donnees.qas datumoj.qas data.qas daten.qas
DESTDIR = /usr/local

# +-------------------------------------------------------------------------+
# | Regles et dependances                                                   |
# +-------------------------------------------------------------------------+

#--- all
all : installer step1 step2

#--- installer
installer : $(OBJS_INSTALLER)
	$(LD) -o $@ $(LDFLAGS) $^

installer.o : installer.c
	$(CC) $(CFLAGS) $(INSTALLERFLAGS) $<

#--- step1
step1 : $(SRCS_STEP1)
	quickasm $< $@

#--- step2
step2 : $(SRCS_STEP2)
	quickasm $< $@

#--- install
install : all
	if [ ! -d $(DESTDIR)/bin ];\
	then mkdir $(DESTDIR)/bin;\
	fi;
	if [ ! -d $(DESTDIR)/boot ];\
	then mkdir $(DESTDIR)/boot;\
	fi;
	if [ ! -d $(DESTDIR)/doc ];\
	then mkdir $(DESTDIR)/doc;\
	fi;
	if [ ! -d $(DESTDIR)/doc/mbrloader2.0-i386 ];\
	then mkdir $(DESTDIR)/doc/mbrloader2.0-i386;\
	fi;
	cp installer $(DESTDIR)/bin/mbrloader2.0-i386;
	chmod 555 $(DESTDIR)/bin/mbrloader2.0-i386;
	rm -f $(DESTDIR)/bin/mbrloader;
	ln -s $(DESTDIR)/bin/mbrloader2.0-i386 $(DESTDIR)/bin/mbrloader;
	cp step1 $(DESTDIR)/boot/mbrloader2.0-i386.step1;
	cp step2 $(DESTDIR)/boot/mbrloader2.0-i386.step2;
	cp LISEZMOI TOOLBOXES ADRESSES DEVICEFILES $(DESTDIR)/doc/mbrloader2.0-i386

#--- clean
clean :
	rm -f *.o *~

distclean : clean
	rm -f step1 step2 installer
