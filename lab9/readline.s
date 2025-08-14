# Lecture de chaines alouées sur le tas

	# Appels système RARS utilisés
	.eqv Sbrk, 9	# Sbrk n'est pas disponible dans libs.s
	.eqv ReadString, 8

	# lit une line dans s0
	li a0, 80
	jal readLine
	mv s0, a0
	
	# lit une autre line dans s1
	li a0, 80
	jal readLine
	mv s1, a0
	
	# affiche les deux lignes
	mv a0, s0
	call printString
	mv a0, s1
	call printString
	
	li a0, 0
	call exit

# readLine: alloue et lit une chaine de `a0` octets
readLine:
	addi sp, sp, -24
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	
	mv s0, a0	# sauve la taille
	li a7, Sbrk
	ecall		# alloue a0 octets
	mv s1, a0	# sauve l'adresse

	# a0 contient deja l'adresse du bloc alloué
	mv a1, s0
	call readString
	mv a0, s1	# retourne l'adresse du bloc allouée (et rempli)
	
	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	addi sp, sp, 24
	ret

#only:rars64
#stdin:hello\nworld\n
#stdout:hello\nworld\n
