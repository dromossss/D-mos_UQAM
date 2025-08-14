# Retourne le nombre milieu entre trois saisies

# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv ReadInt, 5
	.eqv Exit, 10

	# lire n1
	li a7, ReadInt
	ecall
	mv s0, a0		# s0=premier nombre 

	# lire n2
	li a7, ReadInt
	ecall
	mv s1, a0		# s1=second nombre
	ble s0, s1, lire_n3	# si s0 > s1, alors
	mv s1, s0		# on force s0<=s1 en inversant
	mv s0, a0

lire_n3:
	li a7, ReadInt
	ecall
	mv s2, a0		# s2=troisième nombre

	# Il reste trois cas, donc deux comparaisons au pire
	# Objectif: mettre dans s3 le nombre a afficher
	# on sait que s0<=s1
	ble s2, s0, get_s0	# si s2<=s0, on a donc s2<=s0<=s1. c'est s0 au milieux
	
	# autrement, on sait que s0<s2
	ble s2, s1, get_s2	# si s2<=s1, on a donc s0<s2<=s1. c'est s2 au milieux
	
	# autrement, on sait que s0<s1, on a donc s0<=s1<s2. c'est s1 au milieux
	mv s3, s1
	j afficher
	
get_s0:	
	mv s3, s0
	j afficher
	
get_s2: 
	mv s3, s2

afficher:
	li a7, PrintInt
	mv a0, s3
	ecall
	
	li a7, Exit
	ecall

#stdin:10\n20\n30\n
#stdout:20
#only:rars
