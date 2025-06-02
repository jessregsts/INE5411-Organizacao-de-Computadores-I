# Objetivo1: transformar inteiros -> ASCII
# Objetivo2: gerar arquivo .txt com matriz resultante

.data 
matrizA: .word 1, 2, 3, 0, 1, 4, 0, 0, 1   # Matriz A 3x3
matrizB: .word 1, -2, 5, 0, 1, -4, 0, 0, 1 # Matriz B 3x3
matrizC: .space 36 # Espaço para matriz resultado C (3x3 * 4 bytes)
nome_arquivo: .asciiz "matriz_resultado.txt"
buffer: .space 128  # Buffer para armazenar a string da matriz
espaco: .asciiz " "
nova_linha: .asciiz "\n"

.text
principal:
    # Cálculo da matriz C = A * B^t
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
    la $t6, matrizA
    add $t6, $t6, $t5
    lw $t7, 0($t6)         # $t7 = A[i][k]
    
    # calcular B[j][k] (pois B^t[k][j] = B[j][k])
    li $t4, 3              # número de colunas de B
    mul $t5, $t1, $t4      # j * 3
    add $t5, $t5, $t2      # (j*3) + k
    sll $t5, $t5, 2        # * 4
    la $t6, matrizB
    add $t6, $t6, $t5
    lw $t8, 0($t6)         # $t8 = B[j][k]

    # multiplicar e somar
    mul $t9, $t7, $t8
    add $t3, $t3, $t9
    
    addi $t2, $t2, 1       # k++
    li $t4, 3
    blt $t2, $t4, loop_k   # enquanto k < 3
    
    # armazenar C[i][j]
    li $t4, 3
    mul $t5, $t0, $t4      # i * 3
    add $t5, $t5, $t1      # (i*3) + j
    sll $t5, $t5, 2
    la $t6, matrizC
    add $t6, $t6, $t5
    sw $t3, 0($t6)

    addi $t1, $t1, 1       # j++
    li $t4, 3
    blt $t1, $t4, loop_j

    addi $t0, $t0, 1       # i++
    li $t4, 3
    blt $t0, $t4, loop_i

###########################################################
#			OPEN                              #
###########################################################
    # Agora vamos salvar a matriz C no arquivo
    # Primeiro, criar/abrir o arquivo
    li $v0, 13             # syscall para abrir arquivo
    la $a0, nome_arquivo   # nome do arquivo
    li $a1, 1              # flags (1 = escrita)
    li $a2, 0              # modo (ignorado)
    syscall
    move $s6, $v0          # salvar o descritor de arquivo
    
    # Inicializar buffer
    la $s0, buffer         # endereço do buffer
    move $s1, $s0          # ponteiro atual no buffer
    
    # Escrever a matriz no buffer
    li $t0, 0              # i = 0
escrever_loop_i:
    li $t1, 0              # j = 0
escrever_loop_j:
    # Calcular posição C[i][j]
    li $t4, 3
    mul $t5, $t0, $t4      # i * 3
    add $t5, $t5, $t1      # (i*3) + j
    sll $t5, $t5, 2
    la $t6, matrizC
    add $t6, $t6, $t5
    lw $t7, 0($t6)         # $t7 = C[i][j]
    
    # Converter número para ASCII e armazenar no buffer
    move $a0, $t7
    jal inteiro_para_ascii
    
    # Adicionar espaço (exceto após último elemento da linha)
    addi $t1, $t1, 1
    li $t4, 3
    bge $t1, $t4, sem_espaco
    
    # Adicionar espaço
    la $t4, espaco
    lb $t5, 0($t4)
    sb $t5, 0($s1)
    addi $s1, $s1, 1
    
sem_espaco:
    addi $t1, $t1, -1      # ajustar j de volta
    
    addi $t1, $t1, 1       # j++
    li $t4, 3
    blt $t1, $t4, escrever_loop_j
    
    # Adicionar nova linha (exceto após última linha)
    addi $t0, $t0, 1
    li $t4, 3
    bge $t0, $t4, sem_nova_linha
    
    # Adicionar nova linha
    la $t4, nova_linha
    lb $t5, 0($t4)
    sb $t5, 0($s1)
    addi $s1, $s1, 1
    
sem_nova_linha:
    addi $t0, $t0, -1      # ajustar i de volta
    
    addi $t0, $t0, 1       # i++
    li $t4, 3
    blt $t0, $t4, escrever_loop_i
    
###########################################################
#			WRITE                             #
###########################################################
    
    # Escrever buffer no arquivo
    li $v0, 15             # syscall para escrever no arquivo
    move $a0, $s6          # descritor de arquivo
    la $a1, buffer         # buffer
    subu $a2, $s1, $s0     # tamanho = ponteiro atual - início do buffer
    syscall
###########################################################
#			CLOSE                             #
###########################################################    
    # Fechar arquivo
    li $v0, 16             # syscall para fechar arquivo
    move $a0, $s6          # descritor de arquivo
    syscall
    
    # Fim do programa
    li $v0, 10
    syscall

# Função para converter inteiro para ASCII
# Entrada: $a0 = número
# Saída: dígitos armazenados no buffer (apontado por $s1)
inteiro_para_ascii:
    move $t8, $a0          # salvar número original
    li $t9, 10             # divisor
    
    # Tratar caso especial de zero
    bnez $a0, nao_zero
    li $t5, 48             # '0'
    sb $t5, 0($s1)
    addi $s1, $s1, 1
    jr $ra
    
nao_zero:
    # Tratar números negativos
    bgez $a0, positivo
    li $t5, 45             # '-'
    sb $t5, 0($s1)
    addi $s1, $s1, 1
    neg $a0, $a0           # tornar positivo
    
positivo:
    # Contar dígitos
    li $t4, 0              # contador de dígitos
    move $t5, $a0          # cópia do número
    
contar_digitos:
    divu $t5, $t9          # dividir por 10
    mflo $t5               # quociente
    addi $t4, $t4, 1       # incrementar contador
    bnez $t5, contar_digitos
    
    # Armazenar dígitos (começando pelo mais significativo)
    add $s1, $s1, $t4      # avançar para o final
    move $t5, $a0          # cópia do número
    
armazenar_digitos:
    addi $s1, $s1, -1      # retroceder uma posição
    divu $t5, $t9          # dividir por 10
    mfhi $t6               # resto
    mflo $t5               # quociente
    addi $t6, $t6, 48      # converter para ASCII
    sb $t6, 0($s1)         # armazenar dígito
    bnez $t5, armazenar_digitos
    
    add $s1, $s1, $t4      # avançar para após o último dígito
    jr $ra
