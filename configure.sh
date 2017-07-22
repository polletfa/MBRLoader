#!/bin/sh

#             +------------- MBRLoader 0.1-i386 -----------------+
#             | ArnaK, Inc.                                      |
#             |                                                  |
#             | Configuration                                    |
#             +--------------------------------------------------+

echo -e "*** Configuration pour la compilation de MBRLoader 0.1-i386
*** ArnaK, Inc."

# +-------------------------------------------------------------------------+
# | En-tete du fichier                                                      |
# +-------------------------------------------------------------------------+

echo -e ";;             +------------- MBRLoader 0.1-i386 -----------------+
;;             | ArnaK, Inc.                                      |
;;             |                                                  |
;;             | Configuration, genere par configure.sh           |
;;             +--------------------------------------------------+
"> config.qas

# +-------------------------------------------------------------------------+
# | Option prompt                                                           |
# +-------------------------------------------------------------------------+

prompt()
{
echo -e "Voulez-vous que MBRLoader 0.1-i386 vous demande de choisir une
partition a chaque demarrage ?
[o|n] ? "
read rep

if [ "$rep" = "o" ]
then
    echo -e "_prompt:\n .byte 1" >> config.qas
elif [ "$rep" = "n" ]
then
    echo -e "_prompt:\n .byte 0">> config.qas
else
    prompt
fi
}

prompt
unset prompt

# +-------------------------------------------------------------------------+
# | Option default                                                          |
# +-------------------------------------------------------------------------+

if [ "$rep" = "o" ]
then
    echo -e "_default:\n .byte 1" >> config.qas
else
    _default()
    {
    echo -e "Dans ce cas, quelle partition doit-il demarrer ?
1-9, a-g : partitions 1-16 (parmi les partitions principales de type autre que
0, disques 0x80 a 0x83 - id. que les numeros qu'il indiquerait si il demandait).
[1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g] ? "
    read rep

    if [ "$rep" = "1" -o "$rep" = "2" -o "$rep" = "3" -o "$rep" = "4" -o "$rep" = "5" -o "$rep" = "6" -o "$rep" = "7" -o "$rep" = "8" -o "$rep" = "9" ]
    then
	echo -e "_default:\n .byte $rep" >> config.qas
    elif [ "$rep" = "a" ]
    then
	echo -e "_default:\n .byte 10">> config.qas
    elif [ "$rep" = "b" ]
    then
	echo -e "_default:\n .byte 11" >> config.qas
    elif [ "$rep" = "c" ]
    then
	echo -e "_default:\n .byte 12" >> config.qas
    elif [ "$rep" = "d" ]
    then
        echo -e "_default:\n .byte 13" >> config.qas
    elif [ "$rep" = "e" ]
    then
        echo -e "_default:\n .byte 14" >> config.qas
    elif [ "$rep" = "f" ]
    then
        echo -e "_default:\n .byte 15" >> config.qas
    elif [ "$rep" = "g" ]
    then
        echo -e "_default:\n .byte 16" >> config.qas
    else
	_default
    fi
    }
    _default
    unset _default
fi

# +-------------------------------------------------------------------------+
# | Fin                                                                     |
# +-------------------------------------------------------------------------+

echo -e "*** Configuration pour la compilation de MBRLoader 0.1-i386 terminee."
