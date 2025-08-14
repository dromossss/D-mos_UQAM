# Compte les caractère en utilisant libs.s

	li s0, 0	# Compteur
	li s1, '.'	# Caractère de fin de saisie

loop:
	# Lire le caractère suivant dans a0
	call readChar

	# Si c'est '.', on quitte
	beq a0, s1, fin

        # Sinon on incrément le compteur et on recommence
	addi s0, s0, 1
	j loop

fin:
	# Afficher la valeur du compteur
	mv a0, s0
	call printInt

	# Quitte 
	li a0, 0
	call exit

#stdin:bonjour.
#stdout:7
