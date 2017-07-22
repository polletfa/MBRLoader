#!/bin/sh

#             +------------- MBRLoader 0.1-i386 -----------------+
#             | ArnaK, Inc.                                      |
#             |                                                  |
#             | Configuration                                    |
#             +--------------------------------------------------+

echo "*** Configuration pour la compilation de MBRLoader 0.1-i386
*** ArnaK, Inc."

# +-------------------------------------------------------------------------+
# | En-tete du fichier                                                      |
# +-------------------------------------------------------------------------+

echo ";;             +------------- MBRLoader 0.1-i386 -----------------+
;;             | ArnaK, Inc.                                      |
;;             |                                                  |
;;             | Configuration, genere par configure.sh           |
;;             +--------------------------------------------------+
"> config.S

# +-------------------------------------------------------------------------+
# | Option prompt                                                           |
# +-------------------------------------------------------------------------+

prompt()
{
echo "Voulez-vous que MBRLoader 0.1-i386 vous demande de choisir une
partition a chaque demarrage ?
[o|n] ? "
read rep

if [ "$rep" = "o" ]
then
    echo "_prompt: .byte 1" >> config.S
elif [ "$rep" = "n" ]
then
    echo "_prompt: .byte 0">> config.S
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
    echo "_default: .byte 1" >> config.S
else
    _default()
    {
    echo "Dans ce cas, quelle partition doit-il demarrer ?
1-9, a-g : partitions 1-16 (parmi les partitions principales de type autre que
0, disques 0x80 a 0x83 - id. que les numeros qu'il indiquerait si il demandait).
[1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g] ? "
    read rep

    if [ "$rep" = "1" -o "$rep" = "2" -o "$rep" = "3" -o "$rep" = "4" -o "$rep" = "5" -o "$rep" = "6" -o "$rep" = "7" -o "$rep" = "8" -o "$rep" = "9" ]
    then
	echo "_default: .byte $rep" >> config.S
    elif [ "$rep" = "a" ]
    then
	echo "_default: .byte 10">> config.S
    elif [ "$rep" = "b" ]
    then
	echo "_default: .byte 11" >> config.S
    elif [ "$rep" = "c" ]
    then
	echo "_default: .byte 12" >> config.S
    elif [ "$rep" = "d" ]
    then
        echo "_default: .byte 13" >> config.S
    elif [ "$rep" = "e" ]
    then
        echo "_default: .byte 14" >> config.S
    elif [ "$rep" = "f" ]
    then
        echo "_default: .byte 15" >> config.S
    elif [ "$rep" = "g" ]
    then
        echo "_default: .byte 16" >> config.S
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

echo "*** Configuration pour la compilation de MBRLoader 0.1-i386 terminee."

