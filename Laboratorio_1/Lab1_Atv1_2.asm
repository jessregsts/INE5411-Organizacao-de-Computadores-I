
.text
main:
    li $v0, 5         # syscall: read_int
    syscall
    move $t0, $v0     # $t0 = d
    move $t9, $t0     # salva d original em $t9 para uso depois (d³ = d² × d)

    ###### d² = d × d (bit a bit) ######
    li $t1, 0          # $t1 = d² (acumulador)

    # Bit 0
    li $t3, 1          
    and $t4, $t0, $t3  
    sub $t7, $zero, $t4 
    sll $t5, $t0, 0    
    and $t6, $t5, $t7  
    add $t1, $t1, $t6  

    # Bit 1
    li $t3, 2          
    and $t4, $t0, $t3  
    srl $t4, $t4, 1    
    sub $t7, $zero, $t4 
    sll $t5, $t0, 1    
    and $t6, $t5, $t7  
    add $t1, $t1, $t6  

    # Bit 2
    li $t3, 4          
    and $t4, $t0, $t3  
    srl $t4, $t4, 2    
    sub $t7, $zero, $t4 
    sll $t5, $t0, 2    
    and $t6, $t5, $t7  
    add $t1, $t1, $t6  

    # Bit 3
    li $t3, 8          
    and $t4, $t0, $t3  
    srl $t4, $t4, 3    
    sub $t7, $zero, $t4 
    sll $t5, $t0, 3    
    and $t6, $t5, $t7  
    add $t1, $t1, $t6  

    ###### d³ = d² × d ######
    li $t2, 0          # $t2 = d³ (acumulador)
    move $t0, $t9      # recupera d original de $t9

    # Bit 0
    li $t3, 1          
    and $t4, $t0, $t3  
    sub $t7, $zero, $t4 
    sll $t5, $t1, 0    
    and $t6, $t5, $t7  
    add $t2, $t2, $t6  

    # Bit 1
    li $t3, 2          
    and $t4, $t0, $t3  
    srl $t4, $t4, 1    
    sub $t7, $zero, $t4 
    sll $t5, $t1, 1    
    and $t6, $t5, $t7  
    add $t2, $t2, $t6  

    # Bit 2
    li $t3, 4          
    and $t4, $t0, $t3  
    srl $t4, $t4, 2    
    sub $t7, $zero, $t4 
    sll $t5, $t1, 2    
    and $t6, $t5, $t7  
    add $t2, $t2, $t6  

    # Bit 3
    li $t3, 8          
    and $t4, $t0, $t3  
    srl $t4, $t4, 3    
    sub $t7, $zero, $t4 
    sll $t5, $t1, 3    
    and $t6, $t5, $t7  
    add $t2, $t2, $t6  

    ###### Recebe B e E ######
    li $v0, 5
    syscall
    move $t8, $v0      # $t8 = B
    
    li $v0, 5
    syscall
    move $t9, $v0      # $t9 = E

    ###### a = b + 35 + e ######
    addi $t8, $t8, 35  # b + 35
    add $t8, $t8, $t9  # a + e

    ###### resultado = d³ - (a + e) ######
    sub $s3, $t2, $t8  # resultado final em $s3

    ###### print resultado ######
    li $v0, 1
    move $a0, $s3
    syscall

    li $v0, 10
    syscall

#a ordem de insercao é D,B,E