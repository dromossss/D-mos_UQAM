# Comnparaison de chaînes de caractère

### Programme principal / programme de test ###################################
	# Appels systèmes utilisés par le programme de test
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv PrintChar, 11

	.data 
test1: .string "aurore"
test2: .string "arbre"
test3: .string "bonjour" 
#mots stockés dans memoire pour comparer plus tard
	.text
test_strcmp:
	la a0, test1 # Charge l'adresse du mot "aurore" dans a0
	la a1, test2 # Charge l'adresse du mot "arbre" dans a1
	call strcmp # Appelle la fonction strcmp pour comparer les deux mots
	#Affiche si "aurore" est avant, après ou égal à "arbre".
	li a7, PrintInt
	ecall	# Affiche le résultat (-1, 0 ou 1)
	li a0, '\n'
	li a7, PrintChar
	ecall

#comparer arbre et bonjour
	la a0, test2
	la a1, test3
	call strcmp
	li a7, PrintInt
	ecall
	li a0, '\n'
	li a7, PrintChar
	ecall

#comparer aurore et bonjour
	la a0, test3
	la a1, test1
	call strcmp
	li a7, PrintInt
	ecall
	li a0, '\n'
	li a7, PrintChar
	ecall

#comparer aurore et aurore (test d'égalité)
	la a0, test1
	la a1, test1
	call strcmp
	li a7, PrintInt
	ecall
	li a0, '\n'
	li a7, PrintChar
	ecall

	li a7, Exit
	li a0, 0
	ecall

### Routine strcmp ##############################################################

# strcmp: a0 et a1 adresses de deux chaînes à comparer lexicographiquement
#       retour a0: -1 si a0 < a1 ; 0 si a0 = a1; 1 si a0 > a1
# On utilise les registres a pour travailler et on ne fait pas d'appel de de routine.
# On n'a donc pas besoin de prologue ni d'épilogue.
strcmp:
	li a2, 0		# # Initialise le résultat à 0
strcmp_loop:
	lbu t0,0(a0)	# Charge la lettre actuelle de a0 (mot 1)
	lbu t1,0(a1)	# Charge la lettre actuelle de a1 (mot 2)
	
	# Comparaison des deux caractères
	blt t0, t1, strcmp_lt	# Si lettre de a0 < lettre de a1, aller à strcmp_lt (-1)
	bgt t0, t1, strcmp_gt	# Si lettre de a0 > lettre de a1, aller à strcmp_gt (+1)

	# Si l'une des chaînes est finie mais pas l'autre, l'un des test précédent a branché
	beqz t0, strcmp_fin	# les deux chaines sont finie => on retourne 0
	
	# Chaines égale jusqu'à présent, on passe aux caractères suivants
	addi a0,a0,1	# Passe à la lettre suivante de a0
	addi a1,a1,1	# Passe à la lettre suivante de a1
	j strcmp_loop #restart boucle
	
strcmp_lt:
	li a2,-1 	# Charge -1 dans a2 (a0 < a1)
	j strcmp_fin
strcmp_gt:
	li a2,1		# Charge 1 dans a2 (a0 > a1)
strcmp_fin:
	mv a0,a2 # Place le résultat dans a0
	ret # Retourne le résultat

#stdout:1\n-1\n1\n0\n
#only:rars64
