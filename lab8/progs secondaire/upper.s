# Allocation et conversion de chaines dans la pile (Utilise libs.s)
	.data
	.eqv strsize, 81	# taille d'une ligne (en octets, en comtant le '\0' final)
	.eqv str1, +0		# position de str1 dans la pile
	.eqv str2, +81		# position de str2 dans la pile

	.text
	addi sp, sp, -176	# deux chaines de 81 + alignement

	# lire chaine 1 (à sp+str1)
	addi a0, sp, str1
	li a1, strsize
	call readString
	# lire chaine 2 (à sp+str1)
	addi a0, sp, str2
	li a1, strsize
	call readString

	# Transformer en majuscule
	addi a0, sp, str1
	call uppercase
	addi a0, sp, str2
	call uppercase

	# Afficher
	addi a0, sp, str2
	call printString
	addi a0, sp, str1
	call printString

	addi sp, sp, 176	# rend le tas

	li a0, 0
	call exit

uppercase:
	li a2, 'a'
	li a3, 'z'
loop_uppercase:
	lbu a1, (a0)
	beqz a1, fin_uppercase
	blt a1, a2, next_uppercase
	bgt a1, a3, next_uppercase
	addi a1, a1, -0x20 # différence entre majuscules et minuscules en ASCII
	sb a1, (a0)
next_uppercase:
	addi a0, a0, 1
	j loop_uppercase
fin_uppercase:
	ret

#stdin:Hello, World!\nBonjour, le monde!\n
#stdout:BONJOUR, LE MONDE!\nHELLO, WORLD!\n
