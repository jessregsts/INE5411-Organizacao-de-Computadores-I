.data # declaração de variáveis


pede_x: .asciiz "Digite o valor de x: " # string a ser impressa na tela
mostra_seno: .asciiz "Sen(x) = " # string a ser impressa na tela

menos_um: .double -1 # número -1, com tipo double
um: .double 1 # número 1, com tipo double

.text # código executável

main: # parte principal do código

# RECEBE INPUT

#imprime string
li $v0, 4 # $v0 = comando para imprimir string
la $a0, pede_x # $a0 = endereço da string que pede pra usuário digitar x
syscall # mostra string na tela

#recebe x
li $v0, 7 # $v0 = comando para ler double
syscall # $f0 recebe x

# REALIZA CÁLCULO

li $a0, 0 # valor de n usado para calcular a série de taylor, até o vigésimo termo (n = 19)
jal seno # chama o procedimento que calcula o seno pela série de taylor

# IMPRIME OUTPUT

#imprime string
li $v0, 4 # $v0 = comando para imprimir string
la $a0, mostra_seno # $a0 = endereço da string que apresent Sen(x)
syscall # mostra string na tela

#imprime seno
li $v0, 3 # $v0 = comando de imprimir double em $f12
mov.d $f12, $f6 # $f12 = resultado da série de taylor
syscall #imprime sen(x)

# FINALIZA PROGRAMA

j fim # encerra o programa

seno: # procedimento que realiza $f6 = série de taylor para sen(x), restrita a n termos

#salvar dados na pilha
addi $sp, $sp, -8 # aumenta tamanho da pilha
sw $ra, 0($sp) # salva endereço de retorno na pilha
sw $a0, 4($sp) # salva n na pilha
mov.d $f12, $f0 # $f12 armazena x (tivemos problemas com botar doubles na pilha)

beq $a0, 20, fim_seno  # se n = 20, sai da Série de Taylor (vigésimo termo da Série foi calculado)


l.d $f2, um # $f2 = 1 (elemento neutro da multiplicação)
mul $a0, $a0, 2 # a0 = 2n
addi $a0, $a0, 1 # a0 = 2n + 1

jal potencia #chama prodecimento que realiza $f2 =  xˆ(2n+1)

l.d $f4, um # $f4 = 1 (elemento neutro da multiplicação)
l.d $f8, um # var auxiliar para operação fatorial
l.d $f10, um # var auxiliar para operação fatorial

lw $a0, 4($sp) # carrega valor original de n, alterado no loop da potência
mul $a0, $a0, 2 # a0 = 2n
addi $a0, $a0, 1 # a0 = 2n + 1

jal fatorial # chama procedimento que realiza $f4 = (2n+1)!

lw $a0, 4($sp) # carrega valor original de n, alterado no loop de fatorial
mov.d $f0, $f12 # carrega valor original de x, alterado no loop de fatorial

div.d $f4, $f2, $f4 # $f4 = xˆ(2n+1) / (2n+1)!

#agora só falta multiplicar isso por (-1)ˆn e somar o resultado em $f6

l.d $f0, menos_um # altera f0 temporariamente para -1, para poder realizar (-1)ˆn
l.d $f2, um # $f2 = 1 (elemento neutro da multiplicação)

jal potencia # chama procedimento que realiza $f2 = (-1)ˆn

mov.d $f0, $f12 #carrega valor original de x, alterado para realizar potência
lw $a0, 4($sp) # carrega valor original de n, alterado no loop da potência

mul.d $f4, $f2, $f4 # $f4 = (-1)ˆn * xˆ(2n+1)/(2n+1)!

add.d $f6, $f6, $f4 #soma termo da série com o resultado atual

addi $a0, $a0, 1 # n = n + 1
jal seno #chama o procedimento para n+1 (próximo termo d)

fim_seno: # fim do cálculo da Série

# resgata dados da pilha
lw $ra, 0($sp) # carrega endereço de retorno
lw $a0, 4($sp) # carrega n
addi $sp, $sp, 8 # diminui tamanho da pilha

jr $ra # pula para o endereço de retorno

fatorial: # procedimento que realiza $f4 = (2n+1)!

# salva dados na pilha
addi $sp, $sp, -4 # aumenta tamanho da pilha
sw $ra, 0($sp) # salva endereço de retorno na pilha

beqz $a0, fim_fatorial # se n = 0, termina recursões

mul.d $f4, $f4, $f8 # $f4 *= $f8
add.d $f8, $f8, $f10 # $f8 = $f8 + 1
addi $a0, $a0, -1 # n = n - 1

jal fatorial # chama fatorial para n-1 e $f8+1 (recursão)

fim_fatorial: # fim das recursões do procedimento

# resgata dados da pilha
lw $ra, 0($sp) #carrega endereço de retorno
addi $sp, $sp, 4 #diminui tamanho da pilha

jr $ra # pula para endereço de retorno

potencia: # procedimento que realiza xˆ(2n+1) e (-1)ˆn

#salva dados na pilha
addi $sp, $sp, -4 #aumenta tamanho da pilha
sw $ra, 0($sp) #salva endereço de retorno na pilha

beqz $a0, fim_potencia # se n = 0, termina recursões

mul.d $f2, $f2, $f0 # $f2 *= x
addi $a0, $a0, -1 # n = n -1

jal potencia # chama procedimento para n-1 (recursão)

fim_potencia: # fim das recursões do procedimento

#resgata dados da pilha
lw $ra, 0($sp) # carrega endereço de retorno
addi $sp, $sp, 4 # diminui tamanho da pilha

jr $ra # pula para endereço de retorno


fim: #programa finalizado
