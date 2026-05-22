# +-  Programme  -----------------------------------------------------------+
# | MBRToolBox 0.1-i386                                                     |
# | Boîte à outils pour MBRToolBox 2.0-i386 et versions ultérieures         |
# |                                                                         |
# | MBRLoader 2.0-i386                                                      |
# | Gestionnnaire de démarrage "multi-boot"                                 |
# |                                                                         |
# | Voyez la documentation ci-jointe                                        |
# |                                                                         |
# +-  Contacts  ------------------------------------------------------------+
# | http://mbrloader.arnak.cjb.net                                          |
# | mailto:mbrloader@arnak.cjb.net                                          |
# | mailto:mbrtoolbox@arnak.cjb.net                                         |
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
INSTALLERFLAGS = -DFLOPPYDISK=$(FLOPPYDISK)
LD = gcc
LDFLAGS = 

OBJS_INSTALLER = installer.o
SRCS_TOOLBOX = main.qas interf.qas string.qas multil.qas donnees.qas datumoj.qas data.qas daten.qas mbrtoolpart.qas io.qas disk.qas convert.qas

DESTDIR = /usr/local

# +-------------------------------------------------------------------------+
# | Regles et dependances                                                   |
# +-------------------------------------------------------------------------+

#--- all
all : installer toolbox

#--- installer
installer : $(OBJS_INSTALLER)
	$(LD) -o $@ $(LDFLAGS) $^

installer.o : installer.c
	$(CC) $(CFLAGS) $(INSTALLERFLAGS) $<

#--- toolbox
toolbox : $(SRCS_TOOLBOX)
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
	if [ ! -d $(DESTDIR)/doc/mbrtoolbox0.1-i386 ];\
	then mkdir $(DESTDIR)/doc/mbrtoolbox0.1-i386;\
	fi;
	cp installer $(DESTDIR)/bin/mbrtoolbox0.1-i386;
	chmod 555 $(DESTDIR)/bin/mbrtoolbox0.1-i386;
	rm -f $(DESTDIR)/bin/mbrtoolbox;
	ln -s $(DESTDIR)/bin/mbrtoolbox0.1-i386 $(DESTDIR)/bin/mbrtoolbox;
	cp toolbox $(DESTDIR)/boot/mbrtoolbox0.1-i386;
	cp LISEZMOI FORMAT DEVICEFILES $(DESTDIR)/doc/mbrtoolbox0.1-i386

#--- clean
clean :
	rm -f *.o *~

distclean : clean
	rm -f toolbox installer
