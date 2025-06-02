.data

# valores para ler cada linha
ler_linha1: .byte 1
ler_linha2: .byte 2
ler_linha3: .byte 4
ler_linha4: .byte 8
sem_led: .byte 0 # valor para nao mostrar nenhum led

# valores para acender os leds de cada numero
led_0: .byte 63
led_1: .byte 6
led_2: .byte 91
led_3: .byte 79
led_4: .byte 102
led_5: .byte 109
led_6: .byte 125
led_7: .byte 7
led_8: .byte 127
led_9: .byte 111
led_A: .byte 119
led_B: .byte 124
led_C: .byte 57
led_D: .byte 94
led_E: .byte 121
led_F: .byte 113

.text

li $s1, 0xFFFF0010 # armazena em $s1 o endereco do display da direita do Digital Lab Sim
li $s2, 0xFFFF0012 # armazena em $s1 o endereco que ordena qual linha checar
li $s3, 0xFFFF0014 # armazena em $s3 o endereco que reccebe linha e coluna do botao

Loop:  # comeco do loop

LINHA1:
lb $t2,ler_linha1 # escreve em $t2 comando para ler a 1ª linha
sb $t2, 0($s2) # passa o valor de $t2 para endereco de comandos
lb $t3, 0($s3) # poe linha-coluna pressionada em $t3
beqz $t3, LINHA2

# testa cada botao da linha 1
beq $t3, 0x11, Display0
beq $t3, 0x21, Display1
beq $t3, 0x41, Display2 
beq $t3, 0xffffff81, Display3

LINHA2:
lb $t2,ler_linha2 # escreve em $t2 comando para ler a 2ª linha
sb $t2, 0($s2) # passa o valor de $t2 para endereco de comandos
lb $t3, 0($s3) # poe linha-coluna pressionada em $t3
beqz $t3, LINHA3

# testa cada botao da linha 2
beq $t3, 0x12, Display4
beq $t3, 0x22, Display5
beq $t3, 0x42, Display6
beq $t3, 0xffffff82, Display7

LINHA3:
lb $t2,ler_linha3 # escreve em $t2 comando para ler a 3ª linha
sb $t2, 0($s2) # passa o valor de $t2 para endereco de comandos
lb $t3, 0($s3) # poe linha-coluna pressionada em $t3
beqz $t3, LINHA4

# testa cada botao da linha 3
beq $t3, 0x14, Display8
beq $t3, 0x24, Display9
beq $t3, 0x44, DisplayA
beq $t3, 0xffffff84, DisplayB

LINHA4:
lb $t2,ler_linha4 # escreve em $t2 comando para ler a 4ª linha
sb $t2, 0($s2) # passa o valor de $t2 para endereco de comandos
lb $t3, 0($s3) # poe linha-coluna pressionada em $t3
beqz $t3, SemDisplay

# testa cada botao da linha 4
beq $t3, 0x18, DisplayC
beq $t3, 0x28, DisplayD
beq $t3, 0x48, DisplayE
beq $t3, 0xffffff88, DisplayF
j Loop

SemDisplay: lb $t1, sem_led # no caso em que nenhum botao tenha sido pressionado, desliga o display e sai do loop
sb $t1, 0($s1) # passa o valor de $t1 para o display da direita
j Exit

#escreve 0 no display
Display0: lb $t1, led_0
sb $t1, 0($s1)
j Loop

#escreve 1 no display
Display1: lb $t1, led_1
sb $t1, 0($s1)
j Loop

#escreve 2 no display
Display2: lb $t1, led_2
sb $t1, 0($s1)
j Loop

#escreve 3 no display
Display3: lb $t1, led_3
sb $t1, 0($s1)
j Loop

#escreve 4 no display
Display4: lb $t1, led_4
sb $t1, 0($s1)
j Loop

#escreve 5 no display
Display5: lb $t1, led_5
sb $t1, 0($s1)
j Loop

#escreve 6 no display
Display6: lb $t1, led_6
sb $t1, 0($s1)
j Loop

#escreve 7 no display
Display7: lb $t1, led_7
sb $t1, 0($s1)
j Loop

#escreve 8 no display
Display8: lb $t1, led_8
sb $t1, 0($s1)
j Loop

#escreve 9 no display
Display9: lb $t1, led_9
sb $t1, 0($s1)
j Loop

#escreve A no display
DisplayA: lb $t1, led_A
sb $t1, 0($s1)
j Loop

#escreve B no display
DisplayB: lb $t1, led_B
sb $t1, 0($s1)
j Loop

#escreve C no display
DisplayC: lb $t1, led_C
sb $t1, 0($s1)
j Loop

#escreve D no display
DisplayD: lb $t1, led_D
sb $t1, 0($s1)
j Loop

#escreve E no display
DisplayE: lb $t1, led_E
sb $t1, 0($s1)
j Loop

#escreve F no display
DisplayF: lb $t1, led_F
sb $t1, 0($s1)
j Loop

Exit: