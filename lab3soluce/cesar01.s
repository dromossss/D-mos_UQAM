# Appels système utilisés
	.eqv ReadInt, 5
	.eqv Exit, 10	
	.eqv PrintChar, 11
	.eqv ReadChar, 12 
	
	# Lit le décalage dans s0
	li a7, ReadInt
	ecall
	mv s0, a0

	li s1, 'A' # definir Première lettre
	li s2, 'Z' # definir Dernière lettre

loop:
	# Lit la lettre suivante (à convertir)
	li a7, ReadChar
	ecall
	
	# Termine si pas une lettre majuscule
	blt a0, s1, fin #verifie si la lettre est maj
	bgt a0, s2, fin
	
	# Aditionne le décalage
	add a0, a0, s0 #applique le decalage (add s0 au deca)

wrapA:	# pour gerer les lettre qui sortent de l'alphabet
	bge a0, s1, wrapZ
	addi a0, a0, 26
	j wrapA

wrapZ:	# si lettre <z alors réajustée en soustrayant 26 jusqua ce quelle soit dans la plage a-z
	ble a0, s2, affiche
	addi a0, a0, -26
	j wrapZ

affiche:
	li a7, PrintChar
	ecall
	j loop #recommencer avec une autre lettre

fin:	
	li a7, Exit
	li a0, 0
	ecall
	
#skip:.
