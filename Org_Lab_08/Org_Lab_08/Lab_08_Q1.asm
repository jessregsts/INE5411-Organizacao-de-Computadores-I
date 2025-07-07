.eqv MAX 8 # Criando uma constante simbolica, nao fica em nenhum registrador
.eqv TOTAL_BYTES 256 # 8*8*4

.data # Declaracao das variaveis

A: .space 256
B: .space 256
    

.text
.globl main

main:
	la $t0, A         # $t0 <- Endereço de A
	la $t1, B         # $t1 <- Endereço de B
	li $t2, MAX       # $t2 <- Valor de MAX (5)
	li $t3, 0         # $t3 <- Contador i, inicializado com 0

# Laço Externo (i)
loop_externo:
	# Se i $t3 >= MAX, pula para o fim do programa
	bge $t3, $t2, fim_do_programa

	# Inicializa o contador j. Isso deve ser feito a cada iteração de i
	li $t4, 0 # $t4 <- Contador j, inicializado com 0

# Laço Interno (j)
loop_interno:
	# Se j $t4 >= MAX $t2, pula para o fim do laço interno
	bge $t4, $t2, fim_loop_interno

	# Calcular o endereço de A[i,j] -> base(A) + (i * MAX + j) * 4
	mul  $t5, $t3, $t2     # $t5 = i * MAX
	add  $t5, $t5, $t4     # $t5 = i * MAX + j
	sll  $t5, $t5, 2       # $t5 = (i * MAX + j) * 4
	add  $t6, $t0, $t5     # $t6 = Endereço de A[i,j]

	# Calcular o endereço de B[j,i] -> base(B) + (j * MAX + i) * 4
	mul  $t7, $t4, $t2     # $t7 = j ($t4) * MAX ($t2)
	add  $t7, $t7, $t3     # $t7 = (j * MAX) + i ($t3)
	sll  $t7, $t7, 2       # $t7 = (j * MAX + i) * 4
	add  $t8, $t1, $t7     # $t8 = Endereço de B[j,i]

	# Realizar a operação com ponto flutuante (float)
	l.s  $f0, 0($t6)       # Carrega o valor de A[i,j]
	l.s  $f2, 0($t8)       # Carrega o valor de B[j,i]
	add.s $f4, $f0, $f2    # Soma os dois valores
	s.s  $f4, 0($t6)       # Armazena o resultado de volta em A[i,j]

	addi $t4, $t4, 1       # Incrementa j (j++)
	j    loop_interno      # Volta para o início do laço interno

fim_loop_interno:
	# Isso só acontece quando o laço interno (j) termina.
	addi $t3, $t3, 1       # Incrementa i (i++)
	j    loop_externo      # Pula de volta para o início do laço externo

fim_do_programa:
	li   $v0, 10
	syscall
