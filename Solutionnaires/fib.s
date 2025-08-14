# Appels système RARS utilisés
	.eqv PrintInt, 1
	.eqv ReadInt, 5
	.eqv Exit, 10

	# Lire le nombre i dans s0
	li a7, ReadInt
	ecall
	mv s0, a0

	li s1, 0	# a, nombre courant
	li s2, 1	# b, nombre suivant

loop:	blez s0, end	# while(i>0) {
	add s3, s1, s2	#   t = a + n;
	mv s1, s2	#   a = b;
	mv s2, s3	#   b = t;
	addi s0, s0, -1	#   i--;
	j loop		# }

end:
	# Affiche le nombre courant
	li a7, PrintInt
	mv a0, s1
	ecall

	# Quitte
	li a7, Exit
	ecall

#stdin:10
#stdout:55
#only:rars
