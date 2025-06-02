.data # Declaraco de variaveis

# Matriz 16x16 a ser preenchida
data: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text

main:
	la $s0, data
	li $t0, 0 
	li $t2, 0 # $t2 sera nosso contador de colunas (j)
	column_loop: # laco que incrementa j
		beq $t2, 16, exit_column # continua ate que j = 16
		li $t1, 0 # $t1 sera nosso contador de linhas (i)
		row_loop: # laco que incrementa i
			beq $t1, 16, exit_row # continua ate que i = 16
			mul $t3, $t1, 16 # $t3 = i x 16
			add $t3, $t3, $t2 # $t3 = i x 16 + j
			sll $t3, $t3, 2 # $t3 = (i x 16 + j) x 4
			add $t3, $t3, $s0 # $t3 = (i x 16 + j) x 4 + endereco base de data = endereco de data[i][j]
			sw $t0, 0($t3) # data[i][j] = value
			addi $t0, $t0, 1 # value++
			addi $t1, $t1, 1 # i++
			j row_loop # reinicia laco
		exit_row: # fim do laco i
		addi $t2, $t2, 1 # j++
		j column_loop # reinicia laco
	exit_column: # fim do laco j

# programa finalizado
