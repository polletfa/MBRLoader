/*
Installation de MBRLoader 0.4-i386
ArnaK, Inc.

ATTENTION : aucune verification des tailles des parties du chargeur n'est
faite, si les fichiers sont bien ceux de MBRLoader 0.4, il ne doit
pas y avoir de problemes, sinon...

*/

#include <stdio.h>

int main()
{
  FILE *hda,*l1,*l2;
  int c;

  printf("\nATTENTION ! LISEZ BIEN LA DOCUMENTATION AVANT D'INSTALLER MBRLOADER.\nL'AUTEUR NE PEUT ÊTRE TENU POUR RESPONSABLE D'ÉVENTUELS DOMMAGES PROVOQUÉS\nPAR LE PRÉSENT PROGRAMME.\n");
  fgetc(stdin);

  if((hda=fopen("/dev/hda","r+"))==NULL)
    {
      perror("Ouverture de /dev/hda en lecture/écriture impossible ");
      exit(-1);
    }
  if((l1=fopen("/boot/mbrloader0.4-i386.step1","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.4-i386.step1 en lecture impossible ");
      exit(-2);
    }
  if((l2=fopen("/boot/mbrloader0.4-i386.step2","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.4-i386.step2 en lecture impossible ");
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

  printf("MBRLoader 0.4-i386 installé.\n"
	 "Redémarrez votre ordinateur pour pouvoir le configurer.\n");

  return 0;
}
