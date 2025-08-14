# Lit jusqu'à 20 lignes et les affiche en commencant par la dernière.

	.data
	# Appels systmème utilisés
	.eqv PrintString, 4
	.eqv ReadString, 8
	.eqv Exit, 10
	
	
	.eqv maxLine, 81 # espace pour chaque ligne. 80 + 1 pour '\0'
	# Prépare 20 lignes
l00:	.space maxLine
l01:	.space maxLine
l02:	.space maxLine
l03:	.space maxLine
l04:	.space maxLine
l05:	.space maxLine
l06:	.space maxLine
l07:	.space maxLine
l08:	.space maxLine
l09:	.space maxLine
l10:	.space maxLine
l11:	.space maxLine
l12:	.space maxLine
l13:	.space maxLine
l14:	.space maxLine
l15:	.space maxLine
l16:	.space maxLine
l17:	.space maxLine
l18:	.space maxLine
l19:	.space maxLine
	# Un tableau de 20 pointeurs
	.eqv maxLines, 20
lignes:	.dword l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19

.text
	la s0, lignes		# Tableau de lignes
	li s1, 0		# Numéro de la ligne courante (0-basé)

looplire:
	li t0, maxLines
	bge s1, t0, affiche	# for(i=0; i<maxLines; i++) {

	slli s2, s1, 3
	add s2, s2, s0
	lw s2, (s2)		# s2=adresse de la ligne courante

	mv a0, s2
	li a1, maxLine
	li a7, ReadString	# Lit la ligne dans le bon tampon
	ecall
	
	# Force la sortie de la boucle sur une ligne vide
	lb s3, (s2)		# premier caractère de la ligne.
	li t0, '\n'
	beq s3, t0, affiche	# if (ligne[0] = '\n') break;
	beqz s3, affiche	# if (ligne[0] = '\0') break;

	addi s1, s1, 1
	j looplire		# } // for i

	# ici, s1 contient le nombre de lignes lues.
	# la dernière ligne est ligne[s1-1].
affiche:
	blez s1, fin		# while(s1>0) {
	addi s1, s1, -1		#   s1--; // remonte les lignes
	slli s2, s1, 3
	add s2, s2, s0		#   s2 adresse de la ligne à afficher

	lw a0, (s2)
	li a7, PrintString	#   affichage de la ligne
	ecall
	j affiche		# }

fin:	# Terminaison
	li a7, Exit  
	ecall        

#stdin:aaa\nbbb\nccc\n\n
#stdout:ccc\nbbb\naaa\n
#only:64
