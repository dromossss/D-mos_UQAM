# Maximum des éléments d'un tableau 
# Approche: itère un pointeur sur chacun des éléments

	.data
	
	.eqv PrintInt, 1
	.eqv Exit, 10
	
	# Tableau de 10 nombres à additionner (32bits signés)
tab:	.word 10, 10, -6, 20, 1, 1, 8, 800, -800, -2
	.eqv tablen, 10	# Taille du tableau (en nombre d'éléments)

	.text
	la s1, tab		# adr du premier nombre
	li s2, tablen		# prendre le nombre total d'elements a traiter
	lw s0, 0(s1)		# s0 est le nmb max, s1 est le nombre actuel, s2 est le compteur pr savoir les elements restants
loop:
	lw s3, 0(s1)		# lire le nombre actuel
	bge s0, s3, pasmieux 	# # Si s0 est plus grand que s3, on ne change rien
	mv s0, s3		# Sinon, on met a jour le maximum (s0)
	
pasmieux:
	addi s1, s1, 4		# avancer au prochain nmbr
	addi s2, s2, -1 	# Un élément de fait
	bgtz s2, loop		# Faire un tour de plus s'il reste des éléments à traiter (branch if greater than zero)

	# Affichage du résultat et sortie
	li a7, PrintInt
	mv a0, s0 #s0 contient l'element le plus grand donc on l'affiche
	ecall
	
	li a7, Exit
	li a0, 0
	ecall

#stdout:800
