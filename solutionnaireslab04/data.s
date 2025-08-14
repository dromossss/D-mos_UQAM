	.data
	.eqv grains, 0xCAFE #on crée un etiquette appelé grain (51966)
hello: #on crée l'etiquette hello
	.half 42, -2, -0x0A, grains #half pour mettre deux nmbrs dans 2 octets (42= 0x2A, -2=0xFFFE, -10=0xFFF6)
world: #etqt pour stocker un char et un nmbr
	.byte '*' #Stocke le caractère * (42 en ASCII, soit 0x2A).
	.word 0x1EE7C0DE #(4 otets, 32 bits)
# hello commence a 0x10010000
# world commence a 0x10010008 car il suit hello
#'*' est en 0x10010008, mais on doit aligner le .word à 0x1001000C (car .word doit être sur une adr multiple de 4).

# Octet 0  : 0x2A (42)
# Octet 1  : 0x00 
# Octet 2  : 0xFE (-2)
# Octet 3  : 0xFF (
# Octet 4  : 0xF6 (-0x0A)
# Octet 5  : 0xFF 
# Octet 6  : 0xFE
# Octet 7  : 0xCA
# Octet 8  : 0x2A (code ascii de * = 42 = 0x2A)
# Octet 9  : 0x00 alignement du .word donc 9-10-11 sont vides
# Octet 10 : 0x00
# Octet 11 : 0x00
# Octet 12 : 0xDE
# Octet 12 : 0xC0
# Octet 12 : 0xE7
# Octet 12 : 0x1E

# valeur des symboles grains, hello et world ;
# grains est un .eqv et n'a donc pas d'adresse
# hello = 0x10010000 puisque c'est la toute première étiquette du .data
# world = 0x10010008 puisqu'elle réfère à l'octet #8

#exit:cliff_termination


#ce que fait le code : il stock des données en memoires
# un tableau de nombres hello
#un caractere *
#un nombre de 32bits 1EE7CODE
