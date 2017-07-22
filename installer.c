/*
Installation de MBRLoader 0.1-i386
ArnaK, Inc.

ATTENTION : aucune verification des tailles des parties du chargeur n'est
faite, si les fichiers sont bien ceux de MBRLoader 0.1, il ne doit
pas y avoir de problemes, sinon...

*/

#include <stdio.h>

void main()
{
  FILE *hda,*l1,*l2;
  int c;

  if((hda=fopen("/dev/hda","r+"))==NULL)
    {
      perror("Ouverture de /dev/hda en lecture/ecriture impossible ");
      exit(-1);
    }
  if((l1=fopen("/boot/mbrloader0.1-i386.step1","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.1-i386.step1 en lecture impossible ");
      exit(-2);
    }
  if((l2=fopen("/boot/mbrloader0.1-i386.step2","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.1-i386.step2 en lecture impossible ");
      exit(-3);
    }

  // debut du disque
  fseek(hda,0,SEEK_SET);

  // copier l1 vers hda
  while((c=fgetc(l1))!=EOF)
    fputc(c,hda);

  // 2e secteur
  fseek(hda,512,SEEK_SET);

  // copier l2 vers hda
  while((c=fgetc(l2))!=EOF)
    fputc(c,hda);

  printf("MBRLoader 0.1-i386 installe.\n");

}
