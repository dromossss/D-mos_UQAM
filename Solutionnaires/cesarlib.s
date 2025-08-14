# Utilise libs.s

	# Lit le décalage dans s0
	call readInt
	mv s0, a0

	li s1, 'A' # Première lettre
	li s2, 'Z' # Dernière lettre

loop:
	# Lit la lettre suivante (à convertir)
	call readChar
	
	# Termine si pas une lettre majuscule
	blt a0, s1, fin
	bgt a0, s2, fin
	
	# Aditionne le décalage
	add a0, a0, s0

wrapA:	# Ajoute 26 tant que < 'A'
	bge a0, s1, wrapZ
	addi a0, a0, 26
	j wrapA

wrapZ:	# Soustrait 26 tant que > 'Z'
	ble a0, s2, affiche
	addi a0, a0, -26
	j wrapZ

affiche:
	call printChar
	j loop

fin:	li a0, 0
	call exit

#stdin:13\nBONJOUR.
#stdout:OBAWBHE