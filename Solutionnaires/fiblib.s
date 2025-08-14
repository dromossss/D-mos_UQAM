# Utilise libs.s

	# Lire le nombre n dans s0
	call readInt
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
	# Affiche a
	mv a0, s1
	call printInt

	# Quitte
	li a0, 0
	call exit

#stdin:10
#stdout:55
