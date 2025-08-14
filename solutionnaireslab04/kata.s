# Lecture et écriture de nombres en mémoire

	.data 
	
	.eqv PrintInt, 1
	.eqv ReadInt, 5
	.eqv Exit, 10
	.eqv PrintChar, 11 #afficher caractere
	
n1:	.word 0		# premier nombre (32 bits signé) (on reserve la data pour stocker n1,n2)
n2:	.word 0		# second nombre (32 bits signé)
#2 variables qui contiennent le nmbr que l'user va rentrer
	.text
	li a7, ReadInt	# charge le code pour lire un entier
	ecall #appel sys pour demander nmbr a l'user
	sw a0, n1, t0 #stocket le nombre dans n1

	ecall		# Lire n2
	sw a0, n2, t0 #stocker nombre dans n2

	li a7, PrintInt #on affiche l'entier
	lw a0, n1	# charger n1 dans a0
	ecall #affichage du nombre
	
	li a7, PrintChar
	li a0, '\n' #commande pour saut de ligne
	ecall

	li a7, PrintInt
	lw a0, n2	# Afficher n2
	ecall
	
	li a7, PrintChar
	li a0, '\n' #saut de ligne
	ecall

	li a7, Exit #fermeture
	li a0, 0
	ecall

#stdin:10\n20\n
#stdout:10\n20\n
