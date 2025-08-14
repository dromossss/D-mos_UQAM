# Implémentation de readInt via readChar

	# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv ReadChar, 12 #lire un seul cahr a la fois

	li s0, 0 #le nmbr quon veut construire on le mets a 0

loop: #etiquette pr dire quon restart ici
	# Lit le caractère dans s1
	li a7, ReadChar #preparer appel sys pour lire un char
	ecall
	mv s1, a0 #lecture dun caractere et le stocker dans a0

	li t0, '0' #t0 contient la valeur ascii du char 0, pour verifier si ce quon lit est un chiffre
	blt s1, t0, affiche #sauter a l'eti affiche si c'est >0 psq c pas un chiffre
	li t0, '9' #si sup a 9 donc pas chiffre non plus
	bgt s1, t0, affiche

	addi s1, s1, -0x30	# ransforme le caractère ASCII en valeur numérique(0x30 = ASCII de '0')

	li t0, 10	#charger 10 dans t0
	mul s0, s0, t0 #multiplie le nombre dans s0 par 10 (pour deplcaer les chiffres vers la gauche)
	add s0, s0, s1 #ajout du chiffre lu dans s1 au nmbr deja construit s0
	j loop

affiche:
	li a7, PrintInt
	mv a0, s0 #On met le nombre que l'on a construit (qui est dans s0) dans `a0 pour qu'il soit affiché
	ecall

	li a7, Exit
	ecall

#stdin:124\n
#stdout:124
#only:rars
