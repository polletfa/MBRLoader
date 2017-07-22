#             +------------- MBRLoader 0.6-i386 -----------------+
#             | ArnaK, Inc.                                      |
#             |                                                  |
#             | Makefile                                         |
#             +--------------------------------------------------+

# +-------------------------------------------------------------------------+
# | Variables                                                               |
# +-------------------------------------------------------------------------+

CC = gcc
CFLAGS = -c
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
	$(CC) $(CFLAGS) $<

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
	cp installer $(DESTDIR)/bin/mbrloader0.6-i386;
	chmod 555 $(DESTDIR)/bin/mbrloader0.6-i386;
	rm -f $(DESTDIR)/bin/mbrloader;
	ln -s $(DESTDIR)/bin/mbrloader0.6-i386 $(DESTDIR)/bin/mbrloader;
	cp step1 /boot/mbrloader0.6-i386.step1;
	cp step2 /boot/mbrloader0.6-i386.step2;
	if [ ! -d $(DESTDIR)/doc ];\
	then mkdir $(DESTDIR)/doc;\
	fi;
	cp lisezmoi $(DESTDIR)/doc/mbrloader0.6-i386

#--- clean
clean :
	rm -f *.o *~

distclean : clean
	rm -f step1 step2 installer
