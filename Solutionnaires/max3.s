# Retourne le nombre max entre trois saisies

# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv ReadInt, 5
	.eqv Exit, 10

	# Lire le premier nombre dans s0
	li a7, ReadInt
	ecall
	mv s0, a0

	# Lire le premier second nombre dans a0
	ecall
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison1
	mv s0, a0
	
comparaison1:
	# Lire le 3e nombre dans a0
	ecall
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison2
	mv s0, a0
	
comparaison2:
	# Afficher s0
	li a7, PrintInt
	mv a0, s0
	ecall

	# Quitter
	li a7, Exit
	ecall

#stdin:10\n20\n-5\n
#stdout:20
#only:rars
