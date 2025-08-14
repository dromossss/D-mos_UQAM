# Tours de Hanoï, version récursive
# Utilise libs.s pour les entrées/sorties

	.data
hanoi_fmt: .string "Deplacer le disque de %d vers %d.\n"  # Format de sortie pour afficher les déplacements

	.text
	# Lire la hauteur de la tour 1 à déplacer
	call readInt  # Lit un entier (nombre de disques) et le stocke dans a0
	
	# Initialisation des arguments pour la fonction hanoi
	li a1, 1  # Tour de départ = 1
	li a2, 3  # Tour d'arrivée = 3
	li a3, 2  # Tour intermédiaire = 2
	jal hanoi  # Appel récursif de la fonction hanoi

	# Quitter le programme
	li a0, 0  # Code de sortie 0
	call exit  # Appelle la fonction d’arrêt du programme

### Fonction hanoi ###################################
# Paramètres en entrée :
# a0 : nombre de disques à déplacer
# a1 : tour de départ
# a2 : tour d'arrivée
# a3 : tour intermédiaire
	hanoi:
	# Prologue : Sauvegarde de l'état actuel des registres sur la pile
	addi sp, sp, -40  # Alloue de l'espace sur la pile (stack pointer)
	sd ra, 0(sp)   # Sauvegarde de l'adresse de retour ou on pars apres fin de fonction
	sd s0, 8(sp)   # Sauvegarde de s0 (nombre de disques)
	sd s1, 16(sp)  # Sauvegarde de s1 (tour de départ)
	sd s2, 24(sp)  # Sauvegarde de s2 (tour d'arrivée)
	sd s3, 32(sp)  # Sauvegarde de s3 (tour intermédiaire)
	#on sauvegarde les valeurs actuelles (nombre de disques et tours) en mémoire (pile) pour ne pas les perdre.

	# Sauvegarde des arguments dans les registres de sauvegarde
	hanoi_extra:
	mv s0, a0  # s0 = nombre de disques
	mv s1, a1  # s1 = tour de départ
	mv s2, a2  # s2 = tour d'arrivée
	mv s3, a3  # s3 = tour intermédiaire

	# Condition d'arrêt : si nombre de disques <= 0, fin de la récursion
	blez s0, hanoi_fin  # Si s0 <= 0, aller à hanoi_fin

	# Appel récursif pour déplacer n-1 disques vers la tour intermédiaire
	addi a0, s0, -1  # a0 = nombre de disques - 1
	mv a1, s1  # a1 = tour de départ
	mv a2, s3  # a2 = tour intermédiaire
	mv a3, s2  # a3 = tour d'arrivée temporaire
	jal hanoi  # Appel récursif

	# Afficher le mouvement du disque actuel
	la a0, hanoi_fmt  # Charger l'adresse de la chaîne de format
	mv a1, s1  # Premier argument : tour de départ
	mv a2, s2  # Deuxième argument : tour d'arrivée
	call printf  # Affichage du mouvement

	# Appel récursif pour déplacer n-1 disques de la tour intermédiaire à la tour finale
	addi a0, s0, -1  # a0 = nombre de disques - 1
	mv a1, s3  # a1 = tour intermédiaire (devient source)
	mv a2, s2  # a2 = tour d'arrivée
	mv a3, s1  # a3 = ancienne tour de départ (devient intermédiaire)
	#j hanoi_extra  # (optionnel) optimisation de l'appel terminal
	jal hanoi  # Appel récursif
	#On prend les disques qui étaient dans la tour intermédiaire et on les amène vers la tour d’arrivée

	hanoi_fin:
	# Épilogue : restauration des registres sauvegardés
	ld ra, 0(sp)   # Restaurer ra
	ld s0, 8(sp)   # Restaurer s0
	ld s1, 16(sp)  # Restaurer s1
	ld s2, 24(sp)  # Restaurer s2
	ld s3, 32(sp)  # Restaurer s3
	addi sp, sp, 40  # Libérer l'espace de la pile
	
	ret  # Retour à l'appelant
	#Une fois qu’on a fini tous les déplacements, on récupère les anciennes valeurs (qui étaient stockées dans la pile) et on revient au programme principal.


# Entrée : nombre de disques via stdin
# Sortie : Liste des mouvements 
# Exemple avec stdin = 3 :
# stdout:
# Deplacer le disque de 1 vers 3.
# Deplacer le disque de 1 vers 2.
# Deplacer le disque de 3 vers 2.
# Deplacer le disque de 1 vers 3.
# Deplacer le disque de 2 vers 1.
# Deplacer le disque de 2 vers 3.
# Deplacer le disque de 1 vers 3.
