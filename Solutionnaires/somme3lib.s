# Somme de 3 nombres, en utilisant libs.s

	# Lire le premier nombre dans s0
	call readInt
	mv s0, a0
	
	# Lire le 2e nombre et sommer dans s0
	call readInt
	add s0, s0, a0
	
	# Lire le 3e nombre et sommer dans a0
	call readInt
	add a0, s0, a0
	
	# Afficher a0
	call printInt
	
	# Sortir
	li a0, 0
	call exit

#stdin:10\n20\n30\n
#stdout:60
