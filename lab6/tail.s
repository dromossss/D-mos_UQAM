# Affiche les 20 derniers caractère d'une ligne

	.data
	# Appels système utilisés
	.eqv Exit, 10
	.eqv PrintChar, 11
	.eqv ReadChar, 12
	
	
	.eqv bufLen, 20 #tampon qui stock que 20 char
buf:	.space bufLen #buf est ou on va stocker ces caracteres

	.text
	la s0, buf 	# s0 adresse du tampon ou stocker les chars
	li s1, bufLen	# s1 taille du tampon (20)
	li s2, 0	# s2 position courante du tampon (modulo bufLen)
	li s3, 0	# s3 Marqueur qu'on a dépassé (rempli) le tempon

lire:
	li a7, ReadChar #lecture entrée
	ecall
	
	li t0, '\n' #on detecte l'entrée d'un saut de ligne pour arreter la lecture et afficher
	beq a0, t0, afficher
	
	add t0, s0, s2 #calculer ou ranger le caractere dans buf
	sb a0, (t0) #mettre caractere dans ce position

	addi s2, s2, 1 #on avance de 1 dans le tableau
	blt s2, s1, lire # Si on n’a pas encore rempli le tampon (moins de 20 caractères), on continue à lire.
	sub s2, s2, s1 #si on depasse le tampon on recommence de 0
	li s3, 1 #si on depasse 20char alors s3 est TRUE
	j lire

afficher:
	# si `s3` est vrai, afficher de s2 à s1-1
	beqz s3, afficherSuite #si on a pas depassé 20, on affiche, sinon on affiche depuis s2
	mv s4, s2
afficherLoop:
	bge s4, s1, afficherSuite
	add t0, s0, s4
	lbu a0, (t0)
	li a7, PrintChar
	ecall
	addi s4, s4, 1
	j afficherLoop

afficherSuite:
	# Affichage des caractères depuis s2 jusqu’à s1 - 1 (fin du tampon).
	li s4, 0
afficherSuiteLoop:
	bge s4, s2, fin
	add t0, s0, s4
	lbu a0, (t0)
	li a7, PrintChar
	ecall
	addi s4, s4, 1
	j afficherSuiteLoop
	
fin:
	li a7, Exit
	li a0, 0
	ecall

#stdin:Hello, World! Bonjour le monde!\n
#stdout:d! Bonjour le monde!\n
#On lit les caractères un par un et on les stocke dans buf.
#Si on dépasse 20 caractères, on écrase les anciens (tampon circulaire).
#Quand on appuie sur Entrée (\n), on affiche les 20 derniers caractères.
#Si on n’a pas tapé plus de 20 caractères, on affiche tout.
#Sinon, on affiche la fin du tampon + le début, dans l’ordre correct.
