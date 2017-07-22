/*
  MBRLoader v0.2-i386
  Programme de configuration avant compilation
  ArnaK, Inc.
*/

#include <stdio.h>

int main()
{
  int c;
  FILE *config;

  printf("MBRLoader v0.2-i386\n"
	 "Configuration avant compilation\n\n");

  if((config=fopen("config.qas", "w"))==NULL)
    {
      fprintf(stderr, "Impossible de creer le fichier config.qas\n");
      return 1;
    }

  fprintf(config, ";;;             +------------- MBRLoader 0.2-i386 -----------------+\n;;;             | ArnaK, Inc.                                      |\n;;;             |                                                  |\n;;;             | config.qas                                       |\n;;;             +--------------------------------------------------+\n\n");

 print_param:
  printf("[Option print_param] Voulez-vous que MBRLoader affiche les parametres de la partition qu'il va demarrer ? (cette option permet de connaitre les parametres d'une partition pour la configurer comme partition par defaut ensuite) [o|n] ");
  c=fgetc(stdin);
  if(c!='\n')
    while(fgetc(stdin)!='\n')
      ;
  if(c!='o' && c!='n')
    goto print_param;
  if(c=='o')
    fprintf(config,"print_param:\n\t.byte 1\n");
  else
    fprintf(config, "print_param:\n\t.byte 0\n");

 prompt:
  printf("[Option prompt] Voulez-vous que MBRLoader vous demande systematiquement quelle partition demarrer ? [o|n] ");
  c=fgetc(stdin);
  if(c!='\n')
    while(fgetc(stdin)!='\n')
      ;
  if(c!='o' && c!='n')
    goto prompt;
  if(c=='o')
    {
      fprintf(config,"prompt:\n\t.byte 1\ndisk:\nhead:\ncylsect:\n");
    }
  else
    {
      int disk, head, cylsect;

      fprintf(config, "prompt:\n\t.byte 0\n");

      printf("[Parametres Disque/Tete/Cylsect] Dans ce cas, MBRLoader ne vous demandera de choisir une partition que si vous appuyer sur CTRL pendant le demarrage.\n"
	     "Entrez les parametres de la partition qu'il doit demarrer par defaut (ces parametres peuvent etre affiches par MBRLoader lorsque l'option print_param est activee) : [Disque/Tete/Cylsect] ");
      scanf("%x/%x/%x", &disk, &head, &cylsect);

      fprintf(config, "disk:\n\t.byte %#x\nhead:\n\t.byte %#x\ncylsect:\n\t.word %#x\n", disk, head, cylsect);

    }

  printf("Configuration terminee.\n\n");
  fclose(config);
  return 0;
}
