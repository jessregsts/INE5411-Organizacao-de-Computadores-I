.data # declaração de variáveis

# VARIÄVEIS RELACIONADAS AO PROCEDIMENTO:

x: .double 3792 # número do qual se pretende achar a raiz quadrada (nesse caso, 3792)
estimativa: .double 1 # estimativa inicial
div_2: .double 2 # usado para dividir o double por 2

#STRINGS A SEREM IMPRESSAS NO CONSOLE:

pede_n: .asciiz "Digite a quantidade de iterações desejada: "
mostra_raiz: .asciiz "Raiz esperada: "
mostra_estimativa: .asciiz "Raiz estimada: "
mostra_erro: .asciiz "Erro absoluto: "
nova_linha: .asciiz "\n" # símbolo para imprimir nova linha (importante para após imprimir o número nescessário)

.text # código executável

#carrega endereços das variáveis nos registradores $
la $s0, x # $s0 recebe endereço de x
la $s1, estimativa # $s1 recebe endereço de estimativa
la $s2, div_2 # $s2 recebe endereço de div_2

l.d $f0, 0($s0) # $f0 = x
l.d $f2, 0($s1) # $f2 = estimativa
l.d $f4, 0($s2) # $f4 = div_2

# RECEBIMENTO DO INPUT DO USUÄRIO

li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, pede_n #carrega endereço da string que pede pro usuário digitar o valor de n
syscall # imprime a string

li $v0, 5 # carrega em $v0 o comando para ler inteiro
syscall # usuário digita n (quantidade de iterações)
move $a0, $v0 # $a0 = n

# CHAMADA DO PROCEDIMENTO

jal raiz_quadrada # chama o procedimento que estima a raiz quadrada

# OUTPUT DO PROGRAMA

# Output da raiz estimada

li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, mostra_estimativa #carrega endereço da string que pede pro usuário digitar o valor de n
syscall # imprime a string

li $v0, 3 # carrega em $v0 o comando para imprimir double
movf.d $f12, $f2 # move a raiz estimada para o registrador de output de doubles
syscall # imprime a raiz estimada

# imprime uma nova linha
li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, nova_linha #carrega endereço da string
syscall # imprime a string

# Output da raiz esperada

li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, mostra_raiz #carrega endereço da string
syscall # imprime a string

li $v0, 3 # carrega em $v0 o comando para imprimir double
sqrt.d $f12, $f0
syscall

# imprime uma nova linha
li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, nova_linha #carrega endereço da string
syscall # imprime a string

# Output do erro absoluto

li $v0, 4 # carrega em $v0 o comando para imprimir string
la $a0, mostra_erro #carrega endereço da string
syscall # imprime a string

li $v0, 3 # carrega em $v0 o comando para imprimir double
sub.d $f12, $f12, $f2 # $f12 = raiz - estimativa
abs.d $f12, $f12 # $f12 = |raiz - estimativa|
syscall

j exit # finaliza o programa

raiz_quadrada:

#salva dados na pilha
addi, $sp, $sp, -4 # aumenta o tamanho da pilha em 2
sw $ra, 0($sp) # adiciona endereço de retorno na pilha

beqz $a0, fim_raiz # se n = 0, sai das recursões
div.d $f6, $f0, $f2 # $f6 = x/estimativa
add.d $f6, $f6, $f2 # $f6 = (x/estimativa) + estimativa
div.d $f2, $f6, $f4 # estimativa = ((x/estimativa) + estimativa)/2

addi $a0, $a0, -1 # n = n -1
jal raiz_quadrada # chama o procedimento para n-1 e nova estimativa (recursão)

fim_raiz:
# retirar dados na pilha
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

exit: # programa encerrrado
