# Appels systèmes utilisées
	.eqv PrintDouble, 3
	.eqv PrintString, 4
	.eqv ReadDouble, 7
	.eqv Exit, 10
	
	.data
pi: 	.double 3.14159 # Vous pouvez y aller plus ou moins précis, à vous de décider

	.text

	# saisie du rayon
	li a7, ReadDouble
	ecall
	fmv.d fs0, fa0    	# Sauvegarder la valeur de rayon dans fs0

	# saisie de la hauteur
	li a7, ReadDouble
	ecall
	fmv.d fs1, fa0   	# Sauvegarder la valeur de hauteur dans fs1
	
	# load pi dans s2
	fld fs2, pi, t0
		
	# calcul du volume
	fmul.d fa0, fs0, fs0	# fa0 = rayon * rayon
	fmul.d fa0, fa0, fs1	# fa0 = rayon ^2 * hauteur
	fmul.d fa0, fa0, fs2	# fa0 = (rayon^2 * hauteur) * pi
	
	# affichage et fin
	li a7, PrintDouble
	ecall

	li a7, Exit
	ecall
	
#stdin:4\n3
#stdout:150.79631999999998
#only:rars64
