 # Implémentation de readInt via readChar
	.eqv printInt, 1
	.eqv exit, 10
	.eqv printChar, 11
	.eqv readChar, 12

	# Setup des registres importants
	li s0, 0   		# nombre
	li s1, 0   		# booléen de vrai ou faux
	
	
	# 1ere saisie 
	li a7, readChar
	ecall
	li t0, '-'
	bne a0, t0, verifSaisie # Une seule vérif pour le '-' car s'il est rentré en plein milieu c'est invalide
	li s1, 1 		# changer le booléen pour vrai
	
loopSaisie:
	ecall

verifSaisie:
	li t0, '0'
	blt a0, t0, afficher	# if saisie < '0' on fini
	li t0, '9'
	bgt a0, t0, afficher    # if saisie > '9' on fini

ajouterValeur:
	addi a0, a0, -0x30 	# transformer le char en nombre (0x30 = ASCII de '0')
	li t0, 10
	mul s0, s0, t0 		# s0 = s0 * 10 pour décaler la dizaine
	add s0, s0, a0     	# ajout de la nouvelle valeur
	j loopSaisie
	
	
afficher:
	beqz s1, afficherSuite  # si booléen '-' est faux, on saute à afficherSuite
	neg s0, s0		# On transforme notre s0 en valeur négative

afficherSuite:
	li a7, printInt
	mv a0, s0
	ecall
	
	li a7, exit
	li a0, 0
	ecall

#stdin:-128\n
#stdout:-128
#only:rars
	
