
.data  

valor_n: .asciiz "Digite o valor de n: " #string prompt 1 
resultado_fatorial: .asciiz "n! = "  #string prompt 2

.text  

main:  

	#recebe input do usuario
	
	li $v0, 4  # $v0 = comando para imprimir string
	la $a0, valor_n  # $a0 = endereço da string
	syscall  #impirme string
	
	li $v0, 5  #$v0 = comando para ler inteiro
	syscall #v0 = n (input do usuário)
	
	#calculo do fatorial (n!)

	move $a0, $v0  #$a0 = n
	li $v1, 1 # $v1 = 1 (elemento neutro multiplicaco)
	
loop:  #nesse loop, $v1 = n!
	beqz $a0, fim_loop  #se $a0 = 0, sai do loop
	mul $v1, $v1, $a0  #$v1 = vi * n
	addi $a0, $a0, -1 #$a0 = $a0 - 1
	j loop #volta pro loop com $a0 - 1
	
fim_loop:
	
	#output
	
	li $v0, 4  #$v0 = comando para imprimir string
	la $a0, resultado_fatorial  #$a0 = endereço da string que precede output
	syscall  #imprime string
	
	li $v0, 1  #$v0 = comando para imprimir inteiro
	move $a0, $v1  #$a0 = n!
	syscall  #imprime n!
