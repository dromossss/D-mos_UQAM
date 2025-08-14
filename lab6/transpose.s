# Affichage de la transposée d'une matrice 4x3 (tableau de tableaux).

	.data
	# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv PrintChar, 11

	# La matrice à afficher
mat:	.word 11, 12, 13, 14
	.word 21, 22, 23, 24
        .word 31, 32, 33, 34
	.eqv matN, 3 # Nombre de lignes
	.eqv matM, 4 # nombre de colonnes

	.text
	la s0, mat		# Adresse de la matrice

	li s2, 0		# j: index de la colone courante
loopj:	li t0, matM
	bge s2, t0, fin		# for(j=0; j<matM; j++) {

	li s1, 0		#   i: index de la ligne courant
loopi:	li t0, matN
	bge s1, t0, fini	#   for(i=0;i<matN;i++) {

	# Adresse de l'élément (i,j): mat + (i*matM + j) * 4
	li t0, matM
	mul s3, s1, t0		# s3 = i*matM
	add s3, s3, s2		# s3 = i*matM + j
	slli s3, s3, 2		# s3 = (i*matM + j)*4
	add s3, s3, s0		# s3 = mat + (i*matM + j)*4

	# Affichage de l'élément (i,j)
	li a7, PrintInt
	lw a0, 0(s3)
	ecall
	li a7, PrintChar
	li a0, ' '
	ecall

	addi s1, s1, 1
	j loopi			#   } // for i
	
fini:
	li a7, PrintChar
	li a0, '\n'
	ecall

	addi s2, s2, 1
	j loopj			# } // for j

fin:
	li a7, Exit
	ecall

#stdout:11 21 31 \n12 22 32 \n13 23 33 \n14 24 34 \n
#only:rars
