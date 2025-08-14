# Afficle un tableau à l'envers
# Approche: utilise un index de tablen à 1

# Appels systèmes RARS utilisés
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv PrintChar, 11

	.data
	# Tableau de 10 nombres afficher à l'envers (32bits signés)
tab:	.word 10, 10, -6, 20, 1, 1, 8, 800, -800, -2 #on stock 10 nmbr dedans
	.eqv tablen, 10	# Taille du tableau (en nombre d'éléments)

	.text
	li s0, tablen	# Nombre d'éléments restants à traiter donc s0=10
	la s1, tab	# Adresse memoire du tableau

loop:
	addi s0, s0, -1	# inde elements restants a traiter, on diminue par 1 a chaque loop
	# Calcul de l'adresse de l'élément à afficher (adresse=adr de depart +(index*4))
	slli s2, s0, 2	# s2 = s0 * 4 car chaque elements du tab est un entier de 4 octets
	add s2, s2, s1	# s2 = tab + s0 * 4

	#exemple : si s0=9 on prends tab + 9*4 (dernier element)
	#exemple : si s0=8 on prends tab + 8*4 (avant dernier element)

	li a7, PrintInt #affichage de nombre
	lw a0, 0(s2)	# charge le nmbr dans a0
	ecall
	li a7, PrintChar
	li a0, ' ' # espace entre chaque nmbr
	ecall
	bgtz s0, loop	# condition pour l'arret tant que s0>0

	# Sortie
	li a7, Exit
	ecall

#stdout:-2 -800 800 8 1 1 20 -6 10 10 
#only:rars

#on prends le dernier element du tableau, on l'affiche, on ajoute un espace
# on passe a l'element juste avant et on repete la loop jusqua la fin et on quit le programme
