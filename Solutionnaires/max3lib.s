# Note: utilise libs.s

	# Lire le premier nombre dans s0
	call readInt
	mv s0, a0

	# Lire le premier second nombre dans a0
	call readInt
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison1
	mv s0, a0
	
comparaison1:
	# Lire le 3e nombre dans a0
	call readInt
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison2
	mv s0, a0
	
comparaison2:
	# Afficher s0
	mv a0, s0
	call printInt

	# Quitter
	li a0, 0
	call exit

#stdin:10\n20\n-5\n
#stdout:20
