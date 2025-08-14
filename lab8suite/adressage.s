	# Appelant (programme principal)
	
	# call: 0x0000000000400008
	# foo:  0x0000000000400014
	# sp:   0x000000007FFFEFFC
	
	li a0, 42  #a0 recoit 42
	li a1, -2  #A1 RECOIT -2
call:	jal foo  #saut vers prog foo pour ensuite revenir ici
	li a7, 10 # exit
	ecall

	# Appelé (routine)
foo:
	# Prologue
	addi sp, sp, -16  # reserver 16 octets dans la pile
	sd ra, 0(sp) #return adress, stocker adr retour dans la pile
	sw a0, 8(sp) #range a0 en position sp+8
	sw a1, 12(sp) #Range a1 (-2) en position sp + 12.
	
	lb a2, 13(sp) #On prend 1 seul octet ()"load byte") depuis sp + 13 et on le met dans a2
	#Vu que a1 était -2, ça prend la partie mémoire correspondante et la convertit en un nombre.
	ebreak	# <-- ICI on arrete le programme
	
	# [...]
	
# Réponse:
# sp: 0x000000007FFFEFEC (car -16)
# ra: 0x000000000040000C (car foo + 4)
# Pile: 8 octets de ra petit boutiste: 0C 00 40 00 00 00 00 00
#       4 octets de a0 petit boutiste: 2A 00 00 00
#       4 octets de a1 petit boutiste: FE FF FF FF
# a2: 0xFFFFFFFFFFFFFFFF (le 2e octet de a1 dans la pile, avec extension de signe)
#only:rars64
#stdout:
#exit:breakpoint
#résumé
#On met 42 et -2 dans a0 et a1.
#on saute à foo.
#On range ra, a0 et a1 dans la pile.
#On récupère 1 octet d’a1 et le met dans a2.
#On fait un "STOP" avec ebreak.