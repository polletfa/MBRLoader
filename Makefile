#             +------------- MBRLoader 0.1-i386 -----------------+
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
AS86 = as86
AS86FLAGS = 
LD86 = ld86
LD86FLAGS = -d

OBJS_INSTALLER = installer.o
OBJS_STEP1 = bootsect.o
OBJS_STEP2 = main.o disk.o io.o list.o os.o

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
step1 : $(OBJS_STEP1)
	$(LD86) -o $@ $(LD86FLAGS) $^

bootsect.o : bootsect.S
	$(AS86) -o $@ $(AS86FLAGS) $<

#--- step2
step2 : $(OBJS_STEP2)
	$(LD86) -o $@ $(LD86FLAGS) $^

main.o : main.S version step2.S config.S
	$(AS86) -o $@  $(AS86FLAGS) $<

%.o : %.S step2.S
	$(AS86) -o $@ $(AS86FLAGS) $<

config.S :
	make config

config :
	./configure.sh

version :
	./version.sh

#--- install
install : all
	if [ ! -d $(DESTDIR)/bin ];\
	then mkdir $(DESTDIR)/bin;\
	fi;
	cp installer $(DESTDIR)/bin/mbrloader0.1-i386;
	chmod 555 $(DESTDIR)/bin/mbrloader0.1-i386;
	rm -f $(DESTDIR)/bin/mbrloader;
	ln -s $(DESTDIR)/bin/mbrloader0.1-i386 $(DESTDIR)/bin/mbrloader;
	cp step1 /boot/mbrloader0.1-i386.step1;
	cp step2 /boot/mbrloader0.1-i386.step2;
	if [ ! -d $(DESTDIR)/doc ];\
	then mkdir $(DESTDIR)/doc;\
	fi;
	cp lisezmoi $(DESTDIR)/doc/mbrloader0.1-i386

#--- clean
clean :
	rm -f *.o *~

distclean : clean
	rm -f step1 step2 installer config.S version.S
