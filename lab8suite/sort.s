# Lit jusqu'à 20 lignes et les trie

	# Appels système RARS utilisés
	.eqv PrintString, 4
	.eqv ReadString, 8
	.eqv Exit, 10

	.data
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
	# on stocke les adresses de ces lignes dans un tableau 'lignes' :
	.eqv maxLines, 20
lignes:	.dword l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19

.text
	la s0, lignes	# Charger l'adresse du tableau de pointeurs (ou on stocke entrées user)
	li s1, 0		# Numéro de la ligne courante (0-basé) (compteur)

looplire:
	li t0, maxLines
	bge s1, t0, trier	# for(i=0; i<maxLines; i++) { Si on a lu 20 lignes, passer au tri

	slli s2, s1, 3	# Calculer l'offset: s1 * 8 (taille d'un pointeur) car .dword
	add s2, s2, s0	# Pointer vers le bon élément du tableau
	ld s2, (s2)		# s2=adresse du buffer de la ligne courante

	mv a0, s2
	li a1, maxLine
	li a7, ReadString
	ecall			# Lit la ligne dans le bon tampon

	# Force la sortie de la boucle sur une ligne vide
	lb s3, (s2)		# Lire premier caractère de la ligne.
	li t0, '\n'
	beq s3, t0, trier	# if (ligne[0] = '\n') break;
	beqz s3, trier		# if (ligne[0] = '\0') break;
		#Si l'utilisateur appuie juste sur "Entrée", on arrête la lecture.
	addi s1, s1, 1
	j looplire		# } // for i

	# ici, s1 contient le nombre de lignes lues.
	# la dernière ligne est ligne[s1-1].
	
trier: 
	li s4,0 		# indice loop i 
	#rappel ; s0 = tab & s1 = length
	
loopi:
	bge s4,s1, affiche	# Si i >= nombre de lignes lues, passer à l'affichage (s4 indice i)
	li s5,1			# s5 indice loop J
	
loopj:
	bge s5,s1, conti	# Si j >= nombre de lignes lues, passer à l'itération suivante de i
	
	slli s6, s5, 3		#     s6 = j * 8	(taille d'un pointeur)
	add s6, s6, s0		#     s6 = tab + j * 8
	ld s7, 0(s6)		#     s7 = tab[j] contient l'adresse de la ligne tab[j].
	ld s8, -8(s6)		#     s8 = tab[j-1]  contient l'adresse de la ligne tab[j-1].
	
	# Comparaison des cases
	mv a0,s8
	mv a1,s7
	call strcmp
	#-1 si s8 < s7 (correct)
	#0 si s8 == s7 (pas de changement)
	#1 si s8 > s7 (inversion nécessaire)
	
	blez a0, contj		# Si a0 <= 0, ordre correct, ne pas échanger
	# Autrement, on permute(swap) entre tab[j] et tab[i]
	sd s7, -8(s6)
	sd s8, 0(s6)

contj:
	addi s5,s5,1
	j loopj  		#   } // for j
	
conti:	addi s4, s4, 1
	j loopi			# } // for i


affiche:
	li t0,0
affiche_loop:
	bge t0, s1, fin		# for (int i=0; i < s1; i++) {
	slli s2, t0, 3
	add s2, s2, s0

	ld a0, (s2)
	li a7, PrintString
	ecall			#   affichage de la ligne
	addi t0,t0,1
	j affiche_loop		# }

fin:	# Terminaison
	li a7, Exit
	ecall

### Routine strcmp ##############################################################
# Note: on pourrait ne pas la copier-coller et utiliser directement celle de atoi.s

# strcmp: a0 et a1 adresses de deux chaînes à comparer lexicographiquement
#       retour a0: -1 si a0 < a1 ; 0 si a0 = a1; 1 si a0 > a1
# On utilise les registres a pour travailler et on ne fait pas d'appel de de routine.
# On n'a donc pas besoin de prologue ni d'épilogue.
strcmp:
	li a2, 0		# resultat
strcmp_loop:
	lbu t0,0(a0)		# Lire char de a0 
	lbu t1,0(a1)		# lire char de a1
	
	# Comparaison des deux caractères
	blt t0, t1, strcmp_lt	# a0 < a1 => on retourne -1
	bgt t0, t1, strcmp_gt	# a0 > a1 => on retourne +1
	# Si l'une des chaînes est finie mais pas l'autre, l'un des test précédent a branché
	beqz t0, strcmp_fin	# les deux chaines sont finie => on retourne 0
	
	# Chaines égale jusqu'à présent, on passe aux caractères suivants
	addi a0,a0,1
	addi a1,a1,1
	j strcmp_loop
	
strcmp_lt:
	li a2,-1
	j strcmp_fin
strcmp_gt:
	li a2,1
strcmp_fin:
	mv a0,a2
	ret

#stdin:monde\nzzz\nbonjour\nzz\naaa\nle\n
#stdout:aaa\nbonjour\nle\nmonde\nzz\nzzz\n
#only:rars64
