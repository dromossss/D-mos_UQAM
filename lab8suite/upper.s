# Allocation et conversion de chaines dans la pile (Utilise libs.s)
	.data
	.eqv strsize, 81	# taille d'une ligne (en octets, en comtant le '\0' final)
	.eqv str1, +0		# str1 est stockée au début de la pile
	.eqv str2, +81		# str2 est stockée juste après str1 dans la pile

	.text
	addi sp, sp, -176	# deux chaines de 81 + alignement
	#une phrase = 81 octets (80+ \0) x 2 + marge

	# lire chaine 1 (à sp+str1)
	addi a0, sp, str1 #Il stocke la première phrase dans la pile (position str1)
	li a1, strsize	#a1 = taille max de la chaine
	call readString  #focntion pour lire l'entrée user
	# lire chaine 2 (à sp+str1)
	addi a0, sp, str2  #adr pilr
	li a1, strsize	#taille chaine
	call readString

	# Transformer en majuscule
	addi a0, sp, str1 	#charger adr str1
	call uppercase #fonction pour mettre en MAJ
	addi a0, sp, str2
	call uppercase

	# Afficher
	addi a0, sp, str2 # Charge l'adresse de str2 (la deuxième phrase)
	call printString # Affiche la deuxième phrase en majuscules
	addi a0, sp, str1 # Charge l'adresse de str1 (la première phrase)
	call printString  # Affiche la première phrase en majuscules

	addi sp, sp, 176	# rend le tas (libere l'esapce reservé)

	li a0, 0
	call exit

uppercase:
	li a2, 'a'	#valeur ascii de a (97)
	li a3, 'z'  #valeur ascii de z (122)
loop_uppercase:
	lbu a1, (a0) # Charge le caractère courant de la mémoire (octet par octet)
	beqz a1, fin_uppercase	# Si c'est '\0' (fin de chaîne), on arrête
	blt a1, a2, next_uppercase	# Si caractère < 'a', on le laisse tel quel
	bgt a1, a3, next_uppercase	# Si caractère > 'z', on le laisse tel quel
	addi a1, a1, -0x20 # Convertit minuscule → majuscule (ASCII - 32)
	sb a1, (a0)	#stocekr dans memory
next_uppercase:
	addi a0, a0, 1 #passe au prochain char
	j loop_uppercase
fin_uppercase:
	ret

#stdin:Hello, World!\nBonjour, le monde!\n
#stdout:BONJOUR, LE MONDE!\nHELLO, WORLD!\n
