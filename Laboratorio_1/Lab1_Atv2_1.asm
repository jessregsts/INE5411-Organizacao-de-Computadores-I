.data 

.text 
li $s0, 0xFFFF0010 # escreve endereco do display da direita do Digital Lab Sim em $s0

Loop: 

# escreve display de 0: 00111111 = 63
li $t0, 63 
sw $t0, 0($s0)

# escreve display de 1: 00000110 = 6
li $t0, 6 
sw $t0, 0($s0)

# escreve display de 2: 1011011 = 91
li $t0, 91 
sw $t0, 0($s0)

# escreve display de 3: 1001111 = 79
li $t0, 79 
sw $t0, 0($s0)

# escreve display de 4 = 1100110 = 102
li $t0, 102 
sw $t0, 0($s0)

# escreve display de 5 = 1101101 = 109
li $t0, 109 
sw $t0, 0($s0)

# escreve display de 6 = 1111101 = 125
li $t0, 125
sw $t0, 0($s0)

# escreve display de 7 = 0000111 = 7
li $t0, 7 
sw $t0, 0($s0)

# escreve display de 8 = 1111111
li $t0, 127 
sw $t0, 0($s0)

# escreve display de 9 = 1101111
li $t0, 111
sw $t0, 0($s0)

j Loop