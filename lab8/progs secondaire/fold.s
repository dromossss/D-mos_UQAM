# Fonction d'ordre supérieur fold sur les tableau (utilise libs.s)
	.data
	# Un tableau d'exemple
	.eqv tlen, 10 # nombre d'éléments du tableau t
	.eqv esize, 4 # taille d'un élément de t
t:	.word 8, 1, 2, 10, 5, 5, -2, 2, 5, 4

	.text
	# Appel de fold pour calculer la somme
	la a0, t	# tableau parcouru
	li a1, tlen	# nombre d'élement
	li a2, esize	# taille d'un élément
	la a3, somme	# routine de travail
	li a4, 0	# valeur initiale
	call fold
	# Affichage du 
	call printInt
	li a0, '\n'
	call printChar

	# Appel de fold pour chercher l'élément minumal
	la a0, t
	li a1, tlen
	li a2, esize
	la a3, min
	lw a4, 0(a0)	# valeur initiale
	call fold
	call printInt
	li a0, '\n'
	call printChar

	li a0, 0
	call exit

# Additionne a0 et le mot à l'adresse a1
somme:
	lw a1, (a1)
	add a0, a0, a1
	ret

# Retourne l'élément minimum entre a0 et le mot à l'adresse a1
min:
	lw a1, (a1)
	ble a0, a1, fin_min
	mv a0, a1
fin_min:
	ret

#fold: itère sur un tableau et accumule un résultat
# a0: adresse du tableau
# a1: nombre d’éléments du tableau
# a2: taille d'un élément (en octets)
# a3: l’adresse de la routine à appeler
# a4: valeur initiale
# retour a0: valeur accumulée finale
fold:
	# Prologue
	addi sp, sp, -48 # 6 registres sauvés
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)
	sd s4, 40(sp)

	# sauvegarde des arguments
	mv s0, a0	# t: pointeur de l'élément courant
	mv s1, a1	# n: nombre d'éléments restants à traiter
	mv s2, a2	# s: taille d'un élément
	mv s3, a3	# r: routine à exécuter pour chaque élément
	mv s4, s4	# a: accumulateur (valeur initiale et résultat)

	# Boucle pour chaque élément
loop_fold:
	blez s1, fin_fold # il n'y a plus d'éléments à traiter

	# Appel de la routine avec les bons arguments
	mv a0, s4
	mv a1, s0
	jalr s3
	mv s4, a0

	# Fin de boucle
	add s0, s0, s2	# adresse de l'élément suivant
	addi s1, s1, -1	# un élément de moins à traiter
	j loop_fold

fin_fold:
	# Résultat
	mv a0, s4

	# Épilogue
	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	ld s4, 40(sp)
	addi sp, sp, 48 # 6 registres sauvés
	ret

#stdout:40\n-2\n
#only:64
