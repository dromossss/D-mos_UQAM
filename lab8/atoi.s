# Implémentation de atoi

### Programme principal / programme de test ###################################
	# Appels systèmes utilisés par le programme de test
	.eqv PrintInt, 1
	.eqv ReadString, 8
	.eqv Exit, 10

	.data
	.eqv buflen, 80		# Taille du tampon pour lire la chaine
buf:	.space buflen		# Tampon pour lire la chaine

	.text
	# Lire la chaine dans buflen
	li a7, ReadString #demande a lire une chaine
	la a0, buf  #adresse tampon ou stocker chaine
	li a1, buflen #taille de la chaine (char max)
	ecall
	
	# Convertir la chaine en entier
	la a0, buf #charger adresse tampon dans a0
	call atoi #appel fonction convertion texte en nombre
	
	# Afficher la valeur décimale
	li a7, PrintInt
	# a0 est bien placé
	ecall
	
	li a7, Exit
	ecall

### Routine atoi ##############################################################

# atoi: a0: adresse de la chaîne qui contient un entier sous forme décimale.
#       retour a0: valeur numérique.
# On utilise les registres a pour travailler et on ne fait pas d'appel de de routine.
# On n'a donc pas besoin de prologue ni d'épilogue
atoi:
	# a0 contient l'adresse du caractère courant
	li a1, 0		# valeur actuelle du nombre (accumulateur) 0 au début

atoiloop:
	# Lit le caractere courant dans a1
	lb a2, 0(a0)	# caractère courant

	# Termine au premier non-chiffre rencontré
	# note: la fin de chaine ('\0') termine de la même facon.
	li t0, '0'
	blt a2, t0, atoifin #Si a2 < '0', on stoppe
	li t0, '9'
	bgt a2, t0, atoifin # Si a2 > '9', on stoppe

	addi a2, a2, -0x30	# # Convertit '1' ASCII (0x31) en vrai 1
	#En ASCII, '0' = 0x30, '1' = 0x31, '2' = 0x32, etc.
	li t0, 10
	mul a1, a1, t0 #Multiplie le total par 10 (a1 = a1 * 10)
	add a1, a1, a2		# somme = somme*10 + chiffre
	addi a0, a0, 1		# passe au caractère suivant
	j atoiloop		 # Retourne au début de la boucle

atoifin:
	mv a0, a1 # Place le résultat final dans a0
	ret

#stdin:124toto\n
#stdout:124
#only:rars

#résumé:
#Le programme lit une chaîne de caractères.
 #Il convertit les chiffres en nombre entier (atoi).
# Il affiche le résultat et s’arrête.
