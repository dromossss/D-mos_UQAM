# Compte les caractère en utilisant les appels systèmes RARS

	# Appels système utilisés
	.eqv PrintInt, 1 #afficher nmbr
	.eqv ReadChar, 12 #Lire nmbr
	.eqv Exit, 10 #quitter propgramme

	li s0, 0	# Compteur pour compter les caracteres qui commence de 0
	li s1, '.'	# Contient '.' pour arreter le programme a la saisie d'un point

loop:
	# etiquette pour dire qu'ici on va lire un nvl caractere
        li a7, ReadChar # lecture du caractere
	ecall #on demande au sys de faire l'action d'en haut (lire char et stocker dans a0)
	
	# Si c'est '.', on quitte
        beq a0, s1, fin
        
        # Sinon on incrément le compteur et on recommence
        addi s0, s0, 1 #si ce n'est pas un point alors s0 +1 donc on compte un char de +
        j loop #on jump a l'etiquette loop

fin: #si point rencontré on affiche le nmb de char compté
	# Afficher la valeur du compteur
	mv a0, s0
	li a7, PrintInt #indiquer quon veut afficher un nmb avec appel sys
	ecall
	
	# Quitter
	li a7, Exit #sorteie
	ecall

#stdin:bonjour.
#stdout:7
#only:rars
