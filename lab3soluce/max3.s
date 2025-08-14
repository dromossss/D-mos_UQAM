# Retourne le nombre max entre trois saisies

# Appels système RARS utilisés
	.eqv PrintInt, 1 #afficher nombre
	.eqv ReadInt, 5 #lire nombre
	.eqv Exit, 10 #quitte le programme

	# Lire le premier nombre dans s0
	li a7, ReadInt #on demnande au processeur de lire le nombre dans le reg a7
	ecall #appel systeme ( pour lire nmbr et mettre dans a0
	mv s0, a0 #mets le nmbr a0 dans s0

	# Lire le premier second nombre dans a0
	ecall #lire 2eme nombre
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison1 #si a0<s0 alors on saute a comparaison1
	mv s0, a0 #si le deuxieme nmbr est plus grand on remplace s0
	
comparaison1:
	# Lire le 3e nombre dans a0
	ecall
	
	# Garder le plus grand dans s0
	blt a0, s0, comparaison2 #si a0<s0 on saute a compa2
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
