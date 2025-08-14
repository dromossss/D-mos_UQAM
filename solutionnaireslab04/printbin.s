# Lit un nombre et l'affiche en binaire

	# Appels système RARS utilisés
	.eqv PrintInt, 1 #afficher entier
	.eqv ReadInt, 5 #lire entier
	.eqv Exit, 10 #quitter le programme

	# Lire le nombre dans s0
	li a7, ReadInt #preparer appel sys pour lire entier
	ecall
	mv s0, a0	#prendre la valeur lue a afficher en binaire et mettre dans s0

	#ici s1 est un compteur qui commence à 63.donc on veut commencer à examiner le bit le plus à gauche du nombre (le bit le plus significatif).
	li s1, 63	# s1: décalage pour avoir le bit courant
loop:			# boucle pour traiter chaque bit {
	srl s2, s0, s1	# on decale les bits du nmbr de s0 vers la droite de s1 positions
	andi a0, s2, 1	#   a0: extrait le bit courant et fiare un et logique, si cest 1 ,a0 contient 1
	li a7, PrintInt
	ecall
	addi s1, s1, -1	#  diminuer s1 de 1 pour passer au bit suivant
	bgez s1, loop	# si s1 est >=0 donc il reste des bits a traiter, on restart la boucle

	li a7, Exit
	ecall

#stdin:1234
#stdout:0000000000000000000000000000000000000000000000000000010011010010
#skip:32
#only:rars
