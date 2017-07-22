/*
Installation de MBRLoader 0.5-i386
ArnaK, Inc.

ATTENTION : aucune verification des tailles des parties du chargeur n'est
faite, si les fichiers sont bien ceux de MBRLoader 0.5, il ne doit
pas y avoir de problemes, sinon...

*/

#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
  FILE *disque,*l1,*l2;
  int c;
  int hda=1;

  if(argc>1)
    if(!strcmp(argv[1], "--floppy"))
      hda=0;

  printf("\nATTENTION ! LISEZ BIEN LA DOCUMENTATION AVANT D'INSTALLER MBRLOADER.\nL'AUTEUR NE PEUT ÊTRE TENU POUR RESPONSABLE D'ÉVENTUELS DOMMAGES PROVOQUÉS\nPAR LE PRÉSENT PROGRAMME.\n");

  printf("\nAssurez-vous que les fichiers /boot/mbrloader0.5-i386.step1 et /boot/mbrloader0.5-i386.step2 soient bien ceux de MBRLoader 0.5-i386.\n");

  printf("\nMBRLoader va être installé sur %s.\n", hda?"le disque dur hda":"la disquette fd0");

  printf("\nAppuyer sur Entrée ...\n");
  fgetc(stdin);

  if((disque=fopen(hda?"/dev/hda":"/dev/fd0","r+"))==NULL)
    {
      perror("Ouverture de /dev/hda en lecture/écriture impossible ");
      exit(-1);
    }
  if((l1=fopen("/boot/mbrloader0.5-i386.step1","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.5-i386.step1 en lecture impossible ");
      exit(-2);
    }
  if((l2=fopen("/boot/mbrloader0.5-i386.step2","r"))==NULL)
    {
      perror("Ouverture de /boot/mbrloader0.5-i386.step2 en lecture impossible ");
      exit(-3);
    }

  // debut du disque
  fseek(disque,0,SEEK_SET);

  // copier l1 vers le disque
  while((c=fgetc(l1))!=EOF)
    fputc(c,disque);

  // 2e secteur
  fseek(disque,512,SEEK_SET);

  // copier l2 vers le disque
  while((c=fgetc(l2))!=EOF)
    fputc(c,disque);

  printf("MBRLoader 0.5-i386 installé.\n"
	 "Redémarrez votre ordinateur pour pouvoir le configurer.\n");

  return 0;
}
