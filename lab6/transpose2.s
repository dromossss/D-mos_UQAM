# Affichage de la transposée d'une matrice 4x3 (tableau de pointeurs).

	.data
	# La matrice à afficher
mat:	.dword l1, l2, l3 #la matrice contient les adr pointeurs 
#on prends dword car un pointeur est de 8 octets alors que word est en 4 (64vs32bits)
l1:	.word 11, 12, 13, 14
l2:	.word 21, 22, 23, 24
l3:	.word 31, 32, 33, 34
	.eqv matN, 3 # Nombre de lignes
	.eqv matM, 4 # nombre de colonnes

	# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv PrintChar, 11

	.text #initialisation des registres
	la s0, mat		# s0 = Adresse de la matrice

	li s2, 0		# j: index de la colone courante
loopj:	li t0, matM
	bge s2, t0, fin		# for(j=0; j<matM; j++) { loop qui parcourt les colonnes de j=0 a 3

	li s1, 0		#  s1= index de la ligne i
loopi:	li t0, matN
	bge s1, t0, fini	#   for(i=0;i<matN;i++) { si i>= nmbr de lignes on a fini cette colonne

	# Adresse du pointeur vers la ligne i: s4 = mat + i*8
	slli s4, s1, 3		# s4 = i*8 #adresse offset
	add s4, s4, s0		# s4 = mat + i*8 adresse du pointeur de la ligne
	# Déréférencement
	ld s4, (s4)		# s4 = adresse réelle de la ligne
	# Adresse de l'élément i de la ligne j: s3 = ligne + j*4
	slli s3, s2, 2		# s3 = j*4
	add s3, s3, s4		# s3 = ligne + j*4

	#ex : si mat [1,2] =23

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
#only:rars64


#cest un tableau avec pointeurs, a la place de mettre des nombres on utilise des pointeurs
# chaque pointeurs contient l'adressed 'une liste complete