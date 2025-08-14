# Convertit une température de degré Celsius en degré Fahrenheit

	# Appels système RARS utilisé (non disponible avec libs.s)
	.eqv PrintDouble, 3
	.eqv PrintString, 4
	.eqv ReadDouble, 7
	.eqv Exit, 10

	.data
d1.8:	.double 1.8	# Constante 1.8
minT:	.double 82.0	# température minimum
froid:	.string "Trop froid!"

	.text
	# Lit la température en Celsius `c`
	li a7, ReadDouble
	ecall
	
	fld ft0, d1.8, t0	# Charge la constante 1.8 (via un load)
	li t0, 32
	fcvt.d.l ft1, t0	# Charge la constante 32 (via une convertion entière)
	# Calcul combiné: (c*1.8)+32
	fmadd.d fa0, fa0, ft0, ft1
	
	
	fld ft0, minT, t0	# Charge la constante minT (via un load)
	fge.d t0, fa0, ft0 	# fge retourne 1 pour vrai - 0 pour faux
	bnez t0, afficher	# On utilise donc un bnez pour un if (true/false)
	
	li a7, PrintString
	la a0, froid
	ecall
	
	j fin

afficher:
	# Affichage du résultat (seulement si > 82.0 degrés)
	li a7, PrintDouble
	ecall

fin:	
	li a7, Exit
	ecall

#stdin:25
#stdout:Trop froid!
#only:rars64
