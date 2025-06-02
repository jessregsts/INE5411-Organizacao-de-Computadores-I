# Objetivo: calcular C = A * B^t

# Sendo: 
# A (3x3) = 1 2 3
#           0 1 4
#           0 0 1
# B (3x3) = 1 -2  5
#           0  1 -4
#           0  0  1
# B^t (3x3) = 1  0  0
#            -2  1  0
#             5 -4  1
# Para calcular a transposta de uma matriz, basta trocar linhas por colunas
# O resultado C = A × B^t será uma matriz 3×3
# C[i][j] = A[i][k] * B^t[k][j]
#         = A[i][k] * B[j][k]       pois B^t[k][j] = B[j][k]

# Vamos armazenar as matrizes em linha , por exemplo:
# A = [1 2 3  0 1 4  0 0 1]
# B = [1 -2 5  0 1 -4  0 0 1]

.data 
A: .word 1, 2, 3, 0, 1, 4, 0, 0, 1   # Matriz A 3x3
B: .word 1, -2, 5, 0, 1, -4, 0, 0, 1 # Matriz B 3x3
C: .space 36 # Espaço para matriz C (3x3 * 4 bytes) = 9 elementos * 4 (cada inteiro ocupa 4 bytes na arquitetura MIPS (32 bits)) = 36
# Isso reserva 36 bytes de memória para armazenar os 9 inteiros da matriz C
# A: .word 1, 2, 3, 0, 1, 4, 0, 0, 1 
# representa
# A[0][0] = 1   A[0][1] = 2   A[0][2] = 3  
# A[1][0] = 0   A[1][1] = 1   A[1][2] = 4  
# A[2][0] = 0   A[2][1] = 0   A[2][2] = 1
# logo, 
# se a matriz tem 3 colunas, então a posição linear de A[i][k] é: posicao = (i * 3) + k
# Para obter o endereço de memoria real, multiplicamos essa posição por 4 (porque cada inteiro ocupa 4 bytes).
.text

main:
	li $t0, 0 # i = 0 (linha de A)
loop_i:
    	li $t1, 0 # j = 0 (coluna de B^t ou linha de B)
loop_j:
   	li $t2, 0 # k = 0 (índice comum)
    	li $t3, 0 # soma = 0
    	
loop_k:    	
    	# calcular A[i][k]
    	li $t4, 3              # número de colunas de A
    	mul $t5, $t0, $t4      # i * 3
    	add $t5, $t5, $t2      # (i*3) + k
    	sll $t5, $t5, 2        # * 4 (bytes)
    	la $t6, A
    	add $t6, $t6, $t5
    	lw $t7, 0($t6)         # $t7 = A[i][k]
    	
    	# calcular B[j][k] (pois B^[k][j] = B[j][k])
    	li $t4, 3              # número de colunas de B
    	mul $t5, $t1, $t4      # j * 3
    	add $t5, $t5, $t2      # (j*3) + k
    	sll $t5, $t5, 2        # * 4
    	la $t6, B
    	add $t6, $t6, $t5
    	lw $t8, 0($t6)         # $t8 = B[j][k]

	# multiplicar e somar
    	mul $t9, $t7, $t8
    	add $t3, $t3, $t9
    	
    	addi $t2, $t2, 1       # k++
    	li $t4, 3
    	blt $t2, $t4, loop_k   # while k < 3
	
	# armazenar C[i][j]
    	li $t4, 3
    	mul $t5, $t0, $t4      # i * 3
    	add $t5, $t5, $t1      # (i*3) + j
    	sll $t5, $t5, 2
    	la $t6, C
    	add $t6, $t6, $t5
    	sw $t3, 0($t6)

    	addi $t1, $t1, 1       # j++
    	li $t4, 3
    	blt $t1, $t4, loop_j

    	addi $t0, $t0, 1       # i++
    	li $t4, 3
    	blt $t0, $t4, loop_i

    	# fim do programa
    	li $v0, 10
    	syscall
