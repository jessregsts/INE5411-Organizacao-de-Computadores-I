# Objetivo: implementar procedimentos.

.data 
A:  .word 1, 2, 3, 0, 1, 4, 0, 0, 1 # matriz A (3x3)
B:  .word 1, -2, 5, 0, 1, -4, 0, 0, 1 # matriz B 3x3
BT: .space 36 # transposta de B (3x3)
C:  .space 36 # resultado (3x3)

.text
main:
    # chama PROC_TRANS para calcular BT = B^t
    jal PROC_TRANS

    # chama PROC_MUL para calcular C = A * BT
    jal PROC_MUL

    # finaliza o programa
    li $v0, 10
    syscall

###########################################################
# PROC_TRANS: calcula a transposta de B e armazena em BT
# entrada: B 
# saída: BT (transposta de B)
##########################################################

PROC_TRANS:
    li $t0, 0 # i (linha de B)
trans_i:
    li $t1, 0 # j (coluna de B)
trans_j:
    # posição em B: (i*3) + j
    mul $t2, $t0, 3
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, B
    add $t3, $t3, $t2
    lw $t4, 0($t3)

    # posição em BT: (j*3) + i
    mul $t2, $t1, 3
    add $t2, $t2, $t0
    sll $t2, $t2, 2
    la $t3, BT
    add $t3, $t3, $t2
    sw $t4, 0($t3)

    addi $t1, $t1, 1
    li $t5, 3
    blt $t1, $t5, trans_j

    addi $t0, $t0, 1
    blt $t0, $t5, trans_i

    jr $ra

###########################################################
# PROC_MUL: multiplica A por BT e armazena em C
# Entrada: A, BT (transposta de B)
# saída: C
###########################################################

PROC_MUL:
    li $t0, 0 # i (linha de A)
mul_i:
    li $t1, 0 # j (coluna de BT)
mul_j:
    li $t2, 0 # k (índice comum)
    li $t3, 0 # soma acumulada

mul_k:
    # A[i][k]
    mul $t4, $t0, 3
    add $t4, $t4, $t2
    sll $t4, $t4, 2
    la $t5, A
    add $t5, $t5, $t4
    lw $t6, 0($t5)

    # BT[k][j]
    mul $t4, $t2, 3
    add $t4, $t4, $t1
    sll $t4, $t4, 2
    la $t5, BT
    add $t5, $t5, $t4
    lw $t7, 0($t5)

    # soma parcial
    mul $t8, $t6, $t7
    add $t3, $t3, $t8

    addi $t2, $t2, 1
    li $t9, 3
    blt $t2, $t9, mul_k

    # armazena C[i][j]
    mul $t4, $t0, 3
    add $t4, $t4, $t1
    sll $t4, $t4, 2
    la $t5, C
    add $t5, $t5, $t4
    sw $t3, 0($t5)

    addi $t1, $t1, 1
    blt $t1, $t9, mul_j

    addi $t0, $t0, 1
    blt $t0, $t9, mul_i

    jr $ra
