.eqv MAX 8
.eqv BLOCK_SIZE 4


.data

A: .space 256
B: .space 256


.text
.globl main

main:

    la   $t0, A            # Endereço base de A
    la   $t1, B            # Endereço base de B

    li   $s0, MAX          # Carrega MAX em um registrador salvo
    li   $s1, BLOCK_SIZE   # Carrega BLOCK_SIZE em um registrador salvo

    li   $s2, 0            # i = 0

# Laço 1 (for i = 0; i < MAX; i += BLOCK_SIZE) 
loop_i:
    bge  $s2, $s0, end_program
    li   $s3, 0            # j = 0

# Laço 2 (for j = 0; j < MAX; j += BLOCK_SIZE)
loop_j:
    bge  $s3, $s0, end_loop_j

    # Calculando o limite do laço 'ii' -> i + BLOCK_SIZE
    add  $t9, $s2, $s1     # $t9 = i + BLOCK_SIZE
    move $s4, $s2          # ii = i

# Laço 3 (for ii = i; ii < i + BLOCK_SIZE; ii++)
loop_ii:
    bge  $s4, $t9, end_loop_ii

    # Calculando o limite do laço 'jj' -> j + BLOCK_SIZE
    add  $t9, $s3, $s1     # $t9 = j + BLOCK_SIZE (reutilizando $t9)
    move $s5, $s3          # jj = j

# Laço 4 (for jj = j; jj < j + BLOCK_SIZE; jj++)
loop_jj:
    bge  $s5, $t9, end_loop_jj

    # "Corpo" do Laço: A[ii,jj] = A[ii,jj] + B[jj,ii]
    # Endereço de A[ii,jj] = base(A) + (ii * MAX + jj) * 4
    mul  $t5, $s4, $s0     # $t5 = ii * MAX
    add  $t5, $t5, $s5     # $t5 = ii * MAX + jj
    sll  $t5, $t5, 2       # offset em bytes
    add  $t6, $t0, $t5     # Endereço final de A[ii,jj]

    # Endereço de B[jj,ii] = base(B) + (jj * MAX + ii) * 4
    mul  $t7, $s5, $s0     # $t7 = jj * MAX
    add  $t7, $t7, $s4     # $t7 = jj * MAX + ii
    sll  $t7, $t7, 2       # offset em bytes
    add  $t8, $t1, $t7     # Endereço final de B[jj,ii]

    # Realizando operações com floats
    l.s  $f0, 0($t6)       # Carrega A[ii,jj]
    l.s  $f2, 0($t8)       # Carrega B[jj,ii]
    add.s $f4, $f0, $f2    # Soma
    s.s  $f4, 0($t6)       # Salva o resultado em A[ii,jj]

    addi $s5, $s5, 1       # jj++
    j    loop_jj

end_loop_jj:
    addi $s4, $s4, 1       # ii++
    j    loop_ii

end_loop_ii:
    add  $s3, $s3, $s1     # j += BLOCK_SIZE
    j    loop_j

end_loop_j:
    add  $s2, $s2, $s1     # i += BLOCK_SIZE
    j    loop_i

end_program:
    li   $v0, 10    
    syscall