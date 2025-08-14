    .text           # Début du segment de code
    .globl _start   # Point d'entrée du programme

_start:
    # Initialisation des registres avec les valeurs spécifiées
#***** Question 1******************************************
    li t0, 0x3A5F    # t0 = 0x3A5F (14943 en décimal)
    li t1, 0x1234    # t1 = 0x1234 (4660 en décimal)
    li t2, 0xC000    # t2 = 0xC000 (49152 en décimal)
    li t3, 3         # t3 = 3 (en décimal)
    sll t4, t0, t3      
 #***** Question 2******************************************
    srl t4, t1, t3   
#*******Question 3******************************************
    and t4, t0, t1
#*******Question 4******************************************
    or t4, t2, t1 
#*******Question 5******************************************
    mul t4, t2, t1 
#*******Question 6******************************************
    div t4, t2, t1
#*******Question 7******************************************
    srai t4, t0, 2
#*****Question 8*******************************************<
   xor t4, t1, t2