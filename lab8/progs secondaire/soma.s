# Version de soma qui prends les arguments fourni par le terminal 
# Pour lancer ce programme dans le terminal vous devez utiliser :
# java -jar .\rars1_6.jar .\soma_terminal.s .\atoi.s pa 123 toto123 allo 72
# le "pa" signifie passing arguments, voir le manuel -> RARS -> Command
# d'emblé, a0 indique le nom d'arguments (indice de boucle!) et a1 contient un
# tableau des éléments tapés après "-pa". Important de les séparer d'un espace.
# sinon, allez dans settings -> program arguments provided -> buildez
# et ensuite rentrez les arguments dans la petite fenêtre en haut à gauche.

# Attention, utilise la version RARS modifiée avec des pointeurs de 8 octets en RV64 dans le tableau a1
# Note: Utiliser 4 comme décalage et lw pour le RARS par défaut (ou en RV32 bits)

	# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv Exit, 10
	.eqv PrintChar, 11

	mv s0, a0	# Nombre d'arguments
	mv s1, a1	# Tableau d'arguments 
	li s2, 0	# indice loop -> for (int i = 0; i < nombre d'arguments; i++)
	li s3, 0	# Somme des args

loop:
	bge s2,s0, fin	# si i >= nombre arg, on arrête le programme

	# Calcul de l'adresse de l'élément dans a1 (un pointeur vers l'argument)
	# s4 = s1 + s2*8
	slli s4, s2, 3	# i*8
	add s4, s4, s1
	
	ld a0, 0(s4)
	jal atoi
	
	add s3, s3, a0	# mise à jour du résultat
	addi s2, s2, 1	# i++ (fin de boucle)
	j loop
	
fin: 
	li a7, PrintInt
	mv a0, s3
	ecall
	
	li a7, PrintChar
	li a0, '\n'
	ecall
	
	li a7, Exit
	li a0, 0
	ecall

### Routine atoi ##############################################################
# Note: on pourrait ne pas la copier-coller et utiliser directement celle de atoi.s

# atoi: a0: adresse de la chaîne qui contient un entier sous forme décimale.
#       retour a0: valeur numérique.
# On utilise les registres a pour travailler et on ne fait pas d'appel de de routine.
# On n'a donc pas besoin de prologue ni d'épilogue..
atoi:
	# a0 contient l'adresse du caractère courant
	li a1, 0		# valeur actuelle du nombre (accumulateur)

atoiloop:
	# Lit le caracte courant dans a1
	lb a2, 0(a0)	# caractère courant

	# Termine au premier non-chiffre rencontré
	# note: la fin de chaine ('\0') termine de la même facon.
	li t0, '0'
	blt a2, t0, atoifin
	li t0, '9'
	bgt a2, t0, atoifin

	addi a2, a2, -0x30	# Valeur du chiffre (0x30 = ASCII de '0')

	li t0, 10
	mul a1, a1, t0
	add a1, a1, a2		# somme = somme*10 + chiffre
	addi a0, a0, 1		# passe au caractère suivant
	j atoiloop

atoifin:
	mv a0, a1
	ret


#args:10 20 8 4
#only:rars64
#stdout:42
