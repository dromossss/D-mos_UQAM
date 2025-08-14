# Liste chainée de produits
# Code basé sur `produit_liste.s` du cours

	.data
	# Appels système RARS utilisés
	.eqv Sbrk, 9	# Sbrk n'est pas disponible dans libs.s

	# Structure d'un produit
	# La même que celle utilisée en cours
	.eqv prCode, 0	# champ `code` (word) code produit
	.eqv prPrix, 4	# champ `prix` en cents (word) prix du produit
	.eqv prNom, 8	# champ `nom` (dword), adresse d'une chaine de caractères nom produit
	.eqv prNext, 16	# champ `next` (dword), adresse du produit suivant ou null
	.eqv prSize, 24	# taille d'un produit en octets (24 octets)

produit_fmt:	.string "%d: %s (%d.%d$)\n"	# Format d'affichage pour printProduit

	# Liste chaine: tête de liste de produits
head:	.dword 0	# Premier produit de la liste (0 = vide au début)(0)

	.text
	# Lecture de produits du clavier
	# Note: pas d'invite pour simplifier
	# Entrez 0 comme code pour finir
	# Affiche chaque produit après la lecture
	# Ajoute chaque produit lu à la fin de la liste
loop:
	jal readProduit		# demande user d'entrer un produit
	beqz a0, affiche	# 0 entré, fin de la saisie on arrete
	mv s0, a0			# Sauvegarde l'adresse du produit 
	jal addLastProduit	# autrement, ajoute le produit à la liste
	mv a1, s1			# Prépare pour afficher le produi
	jal printProduit	#  Affiche le produit à l'écran 
	j loop	#restar loop
	
affiche:
	# Affiche la somme des prix des produits
	ld a0, head		# premier produit de la liste
	li a1, prNext		# On veut regarder le champ "next"
	la a2, fSumProduit	# Fonction pour additionner les prix
	li a3, 0			# Commence à 0
	jal foldlist		# Fait la somme de tous les produits
	call printInt		# Affiche la somme
	li a0, '\n'
	call printChar		# Va à la ligne

	# Affiche la liste des produits
	ld a0, head		# premier produit de la liste
	li a1, prNext
	la a2, fPrintProduit 
	li a3, 0
	jal foldlist		#parcours et affiche les produits
	li a0, '\n'
	call printChar		#va a la ligne .

	# Affiche le produit le plus cher
	ld a0, head		# premier produit de la liste
	li a1, prNext
	la a2, fMaxProduit		#comparaison des prix
	mv a3, a0		# le plus cher est initialement le premier
	jal foldlist
	jal printProduit		#affichage du produit

	li a0, 0
	call exit

# readLine:Alloue de la mémoire pour un string et la lit`a0` octets
readLine:
	addi sp, sp, -24	# Sauvegarde l'ancien état de la pile
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	
	mv s0, a0	# sauve la taille de la chaine
	li a7, Sbrk		#demande espace memoire
	ecall		# exécute la demande d'allocation memoire
	mv s1, a0	# sauve l'adresse

	# a0 contient deja l'adresse du bloc alloué
	mv a1, s0		#passe la taille a la fonction suivante
	call readString
	mv a0, s1	# retourne l'adresse du bloc allouée (et rempli)
	
	ld ra, 0(sp)	# Restaure l'ancien état de la pile
	ld s0, 8(sp)
	ld s1, 16(sp)
	addi sp, sp, 24
	ret

# chomp: cherche et supprime le premier '\n'
# C'est juste pour que les affichages des produits saisis soient plus jolis
# * a0: adresse de la chaine
# * retour: a0 non modifié
chomp:
	mv a1, a0	# curseur
chomp_loop:
	lb a2, 0(a1)
	beqz a2, chomp_fin	# on trouve deja un '\0', on retourne
	li t0, '\n'
	bne a2, t0, chomp_next	# si on trouve un '\n'
	sb zero, 0(a1)		# alors, on l'ecrase par '\0' et on retourne
	j chomp_fin
chomp_next:
	addi a1, a1, 1		# sinon on boucle avec le caractère suivant
	j chomp_loop
chomp_fin:
	ret

# readProduit: alloue et initialise un produit
# note: pas de message à l'utilisateur pour simplifier.
# ca lit dans l'ordre le code, le prix en cents et le nom.
# Spécial: si le code est 0, alors null est retourné, rien d'autre n'est lu
#          et rien n'est alloué dans le tas.
readProduit:
	addi sp, sp, -32 # Sauvegarde l'ancien état de la pile
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	
	# Lit les 3 champs
	call readInt  		# Demande le code du produit 
	mv s0, a0			#sauvegarde le code
	beqz a0, readProduitFin # Si code = 0, on arrête
	call readInt 		#demande produit
	mv s1, a0			#sauvegarde produit
	li a0, 80 			# max 80 caractères pour le nom. c'est pas idéal mais ça passe
	jal readLine		#demande nom
	jal chomp			# supprime le '\n' (readLine aurait pu le faire, mais bon...)
	mv s2, a0			#sauvegarde le nom
	
	# Alloue un produit avec les valeurs lues
    mv a0, s0  # Code
    mv a1, s1  # Prix
    mv a2, s2  # Nom
	jal allocProduit2
	# a0 est l'adresse du produit alloué.
	# C'est parfait, c'est ce qu'on veut retourner
	
readProduitFin:
	ld ra, 0(sp)  # Restaure l'ancien état de la pile
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	addi sp, sp, 32
	ret

#addLastProd: ajoute un produit à la fin de la liste chainée `head`
# * a0: adresse du produit à ajouter
addLastProduit:
	la a1, head 	# Prend l'adresse de la tête de liste
	ld a2, 0(a1)			# a2 = head; // charge premier produit
    # Si la liste est vide, on met directement le produit en tête
    bnez a2, addLastProd_loop   # Si la liste n'est pas vide, on continue
    sd a0, 0(a1)  				# Sinon, on met le produit en tête 
    j addLastProd_fin  			# On termine
					# }
addLastProd_loop:
	# cas général: liste non vide
	# on parcourt la liste jusqu'au dernier produit
    ld a3, prNext(a2)  # Prend le produit suivant
    beqz a3, addLastProd_add  		# Si c'est le dernier, on ajoute après
    mv a2, a3  						# Passe au produit suivant
    j addLastProd_loop  			# Continue

addLastProd_add:
	# on a trouvé le dernier produit (a2), on y accroche l'argument (a0)
	sd a0, prNext(a2)		# a2.next = a0 ajout produita la fin

addLastProd_fin:
	ret

#foldlist: itere sur une liste et accumule un résultat (cf fold des tableaux)
# * a0: l’adresse d’un maillon (ou null pour une liste vide)
# * a1: le décalage du pointeur vers le maillon suivant (prNext pour les produits par exemple)
# * a2: l’adresse d’une routine à appeler
# * a3: une valeur initiale
# * retour a0: la valeur accumulée
foldlist:  #sauvegarde des registres
	addi sp, sp, -40
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)
	
	mv s0, a0	# adr Maillon courant (pointeur vers le premier élément de la liste)
	mv s1, a1	# adr Décalage pour accéder au champ "next"
	mv s2, a2	# adr Routine à invoquer (fonction appliquée)
	mv s3, a3	# Valeur accumulée initiale
	
foldlist_loop:
	beqz s0, foldlist_fin	# while (s0 != null) {

	# appel de la routine
	mv a0, s3		#   1er argument: valeur accumulée actuelle
	mv a1, s0		#   2e argument: pointeur vers le maillon
	jalr s2			#   appel indirect de la routine
	mv s3, a0		#   résultat: nouvelle valeur accumulée (stockée dans s3)
		#On passe la valeur accumulée et l'élément courant à la fonction (s2)

	# faire pointer s0 pointer sur le maillon suivant (ou null si pas de suivant)
	add a0, s0, s1		#   calcul de l'adresse du champ next 
	ld s0, 0(a0)		#   s0 = s0.next; // déréférencement (pointeur vers le prochain maillon)
	j foldlist_loop		# }

foldlist_fin:
	mv a0, s3		# Le résultat est la valeur finale (a0)
	 #restauration des registres
	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	addi sp, sp, 40
	ret

# fSumProduit: somme les prix des produits
# * a0: somme précédente
# * a1: adresse d'un produit
# * resultat a0: nouvelle somme
fSumProduit:
	# return a0 + a1.prix;
	lw a2, prPrix(a1)	# Charger le prix de l'élément
	add a0, a0, a2		# Additionner au total accumulé
	ret

# fPrintProduit: version de printProduit utilisable avec foldlist
# * a0: ignoré
# * a1: adresse d'un produit a afficher
# * resultat a0: ignoré
fPrintProduit:
	mv a0, a1
	j printProduit	# tail call printProduit

# fMaxProduit
# * a0: adresse d'un produit
# * a1: adresse d'un autre produit
# * resultat a0: l'adresse du produit le plus cher des deux
fMaxProduit:
	lw t0, prPrix(a0)
	lw t1, prPrix(a1)
	bge t0, t1, fMaxProduitFin #Compare les prix a0 et a1 et donne adr du produit le plus cher.
	mv a0, a1
fMaxProduitFin:
	ret

### Routines vues en cours (anciennes)

# printProduit: affiche un produit
# a0: adresse du produit a afficher
printProduit:
	lw a1, prCode(a0)
	ld a2, prNom(a0)
	lw t0, prPrix(a0)
	li t1, 100
	div a3, t0, t1
	rem a4, t0, t1
	la a0, produit_fmt
	tail printf
	
# Alloue et initialize un produit dans le tas RARS
# * a0: son code
# * a1: son prix en cent
# * a2: son nom
allocProduit2:
	mv a3, a0
	li a7, Sbrk
	li a0, prSize
	ecall
	sw a3, prCode(a0)
	sw a1, prPrix(a0)
	sd a2, prNom(a0)
	sd zero, prNext(a0)	# next = null
	ret

#only:rars64
#stdin:123\n1995\nUne tuque a ponpon\n234\n2545\nDe belles mitaines\n345\n1545\nUn cache cou chic\n0\n
#stdout:123: Une tuque a ponpon (19.95$)\n234: De belles mitaines (25.45$)\n345: Un cache cou chic (15.45$)\n6085\n123: Une tuque a ponpon (19.95$)\n234: De belles mitaines (25.45$)\n345: Un cache cou chic (15.45$)\n\n234: De belles mitaines (25.45$)\n

## **Conclusion**
#Ce programme assembleur fait une **liste de produits** comme une **chaîne** de perles.  
#Tu peux **ajouter, afficher et chercher le plus cher**