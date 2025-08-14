	.data
d:	.dword 0x0123456789ABCDEF #stocker un nmbr de 8 octets en memoire
	.text
	la s0, d #s0 contient l'adresse de d
	lw s1, 0(s0) #on charge les valeurs dans les reg de s1 a s7
	lb s2, 0(s0) #load byte signé pour charger EF (quand c'est signé, les cases vite sont remplacées par F)
	lb s3, 1(s0)
	lbu s4, 2(s0) #load byte Unsigned (donc on remplace par 0)
	lw s5, 0(s0) #prends 4 d'adresse de 0 a 3 donc EF CD AB 89 et on mets f car 89 est -
	lhu s6, 4(s0) # prends 4 adresses
	lw s7, 4(s0) #il essaye de prendre 4 adresse en commencant de l'adr2 donc ca crash car cest pas aligné
	# lwu s7, 4(s0)   # ✅ Adresse 4 (alignée) → Attrape les octets 4,5,6,7 est l'utilisation correcte

#en little endian, les octets sont stockés a l'envers en memoire, donc :
# d+0=EF,d+1=CD,d+3=89, 67,45,23,01

# Avant de se lancer dans l'exercice, écrivons les octets représentants 'd'
# octet 0 : 0xEF
# octet 1 : 0xCD
# octet 2 : 0xAB
# octet 3 : 0x89
# octet 4 : 0x67
# octet 5 : 0x45
# octet 6 : 0x23
# octet 7 : 0x01

# s1 = 0x0123456789ABCDEF
# s2 = 0xFFFFFFFFFFFFFFEF (load byte signé, on recopie le bit de poids fort et EF = 1110 1111)
# s3 = 0xFFFFFFFFFFFFFFCD (idem mais CD = 1100 1101)
# s4 = 0x00000000000000AB (load byte unsigned donc on ne recopie pas le bit de poids fort)
# s5 = 0xFFFFFFFF89ABCDEF (load word signé sur 0x89ABCDEF = 1000 1001 1010 1011 1100 1101 1110 1111, recopie 1)
# s6 = 0x0000000000004567 (load half unsigned)
# s7 = fait planter le programme puisque les words sont alignés sur des multiples de 4 et 2/4 n'est pas possible.
	
#skip:.


#ce code mets de gros nombres en memoire et va chercher des morceaux de ce nombre pour les mettres dans
# des registres de s1 a s7
