
.data  


valor_n: .asciiz "Digite o valor de n: " #string prompt 1 
resultado_fatorial: .asciiz "n! = "  #string prompt 2

.text  


main:  

	#recebe input do usuario
	
	li $v0, 4  #$v0 = comando para imprimir string
	la $a0, valor_n  #$a0 = endereço da string
	syscall  #impirme string
	
	li $v0, 5  #$v0 = comando para ler inteiro
	syscall #v0 = n (input do usuário)
	
	#calculo do fatorial (n!)

	move $a0, $v0  #$a0 = n
	li $v1, 1 #$v1 = 1 (elemento neutro multiplicaco)
	
	jal fatorial
	
	#output
	
	li $v0, 4  #$v0 = comando para imprimir string
	la $a0, resultado_fatorial  #$a0 = endereço da string que precede output
	syscall  #imprime string
	
	li $v0, 1  #$v0 = comando para imprimir inteiro
	move $a0, $v1  #$a0 = n!
	syscall  #imprime n!
	
	j exit  #fim do programa

fatorial:  #procedimento que realiza n!

	#salvar dados na pilha
	addi $sp, $sp, -4  #aumenta tamanho da pilha
	sw $ra, 0($sp)  #salva endereço de retorno na pilha

	beqz $a0, fim_fatorial  #se $a0 = 0, para as recursões
	mul $v1, $v1, $a0  #$v1 = v1 * n
	addi $a0, $a0, -1  #$a0 = n -1
	jal fatorial #chama função para n - 1 (recursão)

fim_fatorial:  #fim das recursões
	#resgata dados da pilha
	lw $ra, 0($sp)  #resgata endereço de retorno da pilha
	addi $sp, $sp, 4 #diminui tamanho da pilha

	jr $ra  #pula para o endereço de retorno

exit:
