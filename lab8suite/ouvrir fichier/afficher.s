.text
.eqv  maxchar 1024

main:
    addi    sp, sp, -16

    lw      a0, 0(a1)    # nom du fichier
    li      a1, 0        # mode lecture
    li      a7, 1024     # syscall open
    ecall                 
    mv      s0, a0       
    bltz    a0, err      # vérifie si erreur

    la      a1, input    # buffer de lecture
    li      a2, maxchar  # taille max
    li      a7, 63       
    ecall                 # lecture
    mv      s1, a0       # sauvegarde du nombre d'octets lus

    mv      a0, s0      
    li      a7, 57       
    ecall                 # fermer fichier

    la      a0, input    # affichage du buffer
    li      a7, 4       
    ecall

    j       fin

err:
    la      a0, str_err  # message d'erreur
    li      a7, 4
    ecall

fin:
    li      a7, 10       # Quitter
    ecall

.data
input: .space maxchar
str_err: .asciz "Erreur lors de l'ouverture du fichier\n"