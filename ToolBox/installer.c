/*
** +-  Programme  -----------------------------------------------------------+
** | Programme d'installation de MBRToolBox 0.1-i386                         |
** |                                                                         |
** | MBRToolBox 0.1-i386                                                     |
** | Boîte à outils pour MBRToolBox 2.0-i386 et versions ultérieures         |
** |                                                                         |
** | MBRLoader 2.0-i386                                                      |
** | Gestionnnaire de démarrage "multi-boot"                                 |
** |                                                                         |
** | Voyez la documentation ci-jointe                                        |
** |                                                                         |
** | AVERTISSEMENT : aucune verification de taille n'est faite, si le        |
** | fichier est bien celui de MBRToolBox 0.1, il ne doit pas y avoir de     |
** | problemes, sinon...
** |                                                                         |
** +-  Contacts  ------------------------------------------------------------+
** | http://mbrloader.arnak.cjb.net                                          |
** | mailto:mbrloader@arnak.cjb.net                                          |
** | mailto:mbrtoolbox@arnak.cjb.net                                         |
** | mailto:mbrtoolbox.install@arnak.cjb.net                                 |
** |                                                                         |
** +-  Auteur  --------------------------------------------------------------+
** | ArnaK, SARL / Rip-off, Inc. / Kompanio Fraudo / Schwindel, GmbH         |
** | Fabien Pollet                                                           |
** | http://www.arnak.cjb.net                                                |
** | mailto:arnak@arnak.cjb.net                                              |
** |                                                                         |
** +-  Fichier  -------------------------------------------------------------+
** | installer.c                                                             |
** | Programme d'installation                                                |
** +-------------------------------------------------------------------------+
*/

#include <stdio.h>
#include <string.h>

int commande_aide(char*);

int main(int argc, char **argv)
{
  FILE *disque,*l1,*l2;
  int c;
  char dev[4096]=FLOPPYDISK;

  if(argc==3)
    {
      if(!strcmp(argv[1], "--device"))
	strcpy(dev,argv[2]);
      else return commande_aide(argv[0]);
    }
  else if(argc!=1)
    return commande_aide(argv[0]);

  printf("\nATTENTION ! LISEZ BIEN LA DOCUMENTATION AVANT D'INSTALLER MBRTOOLBOX.\nCE PROGRAMME EST DISTRIBUÉ UNIQUEMENT DANS L'ESPOIR QU'IL SERA UTILE MAIS SANS\nAUCUNE GARANTIE D'AUCUNE SORTE, NI MÊME LA GARANTIE IMPLICITE DE BON\nFONCTIONNEMENT OU DE QUALITÉ.\nL'AUTEUR NE PEUT DONC ÊTRE TENU POUR RESPONSABLE D'ÉVENTUELS DOMMAGES PROVOQUÉS\nPAR LE PRÉSENT PROGRAMME.\n");

  printf("\nAssurez-vous que le fichier /usr/local/boot/mbrtoolbox0.1-i386 soit bien celui de MBRToolBox 0.1-i386.\n");

  printf("\nMBRToolBox va être installé sur %s.\n", dev);

  printf("\nAppuyez sur Entrée (ou CTRL-C pour annuler) ...\n");
  fgetc(stdin);

  if((disque=fopen(dev,"r+"))==NULL)
    {
      perror("Ouverture du fichier de périphérique en lecture/écriture impossible ");
      exit(-1);
    }
  if((l1=fopen("/usr/local/boot/mbrtoolbox0.1-i386","r"))==NULL)
    {
      perror("Ouverture de /usr/local/boot/mbrtoolbox0.1-i386 en lecture impossible ");
      exit(-2);
    }

  // secteur 19
  fseek(disque,18*512,SEEK_SET);

  // copier l1 vers le disque
  while((c=fgetc(l1))!=EOF)
    fputc(c,disque);

  printf("MBRToolBox 0.1-i386 installé.\n"
	 "Vous pouvez la lancer depuis MBRLoader 2.0-i386 et versions ultérieures.\n");

  return 0;
}

int commande_aide(char *prog)
{
  printf("MBRToolBox 0.1-i386\n"
	 "Programme d'installation\n"
	 "\n"
	 "ArnaK, SARL\n"
	 "mbrtoolbox.install@arnak.cjb.net\n"
	 "\n"
	 "%s                        Installation sur " FLOPPYDISK "\n"
	 "%s --device device_file   Installation sur device_file\n"
	 "\n", prog,prog);
  return -1;
}
