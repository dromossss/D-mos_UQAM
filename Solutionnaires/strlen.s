# Compte les caractère en utilisant les appels systèmes RARS

	# Appels système utilisés
	.eqv PrintInt, 1
	.eqv ReadChar, 12
	.eqv Exit, 10

	li s0, 0	# Compteur
	li s1, '.'	# Caractère de fin de saisie

loop:
	# Lire le caractère suivant dans a0
        li a7, ReadChar
	ecall
	
	# Si c'est '.', on quitte
        beq a0, s1, fin
        
        # Sinon on incrément le compteur et on recommence
        addi s0, s0, 1
        j loop

fin:
	# Afficher la valeur du compteur
	mv a0, s0
	li a7, PrintInt
	ecall
	
	# Quitter
	li a7, Exit
	ecall

#stdin:bonjour.
#stdout:7
#only:rars
