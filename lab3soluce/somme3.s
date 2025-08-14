# Somme de 3 nombres en utilisant les appels systèmes RARS

# Appels système utilisés
	.eqv PrintInt, 1
	.eqv ReadInt, 5
	.eqv Exit, 10

	# Lire le premier nombre dans s0
	li a7, ReadInt
	ecall
	mv s0, a0

	# Lire le 2e nombre et sommer dans s0
	ecall
	add s0, s0, a0

	# Lire le 3e nombre et sommer dans a0
	ecall
	add a0, s0, a0

	# Afficher a0
	li a7, PrintInt
	ecall

	# Sortir
	li a7, Exit
	ecall

#stdin:10\n20\n30\n
#stdout:60
#only:rars
