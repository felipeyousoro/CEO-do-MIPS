.data
ent: .asciiz "Insira o valor de Vet["
ent2: .asciiz "]: "

.align 2

.text

.macro printS(%str)
.data
macroS: .asciiz %str
.text
li $v0, 4
la $a0, macroS
syscall
.end_macro

main: 	
	jal criarVetor
	move $a0, $v0
        jal leitura
        move $a0, $v0
        jal ordenar
        move $a0, $v0
        jal escritaPrimeiros
        move $a0, $v0
        jal escritaUltimos
        li $v0, 10
        syscall


criarVetor:
	printS("Insira o valor de N: ")
	li $v0 5
	syscall
	move $s0, $v0
	sll $a0 $v0 2    
	li $v0 9          
	syscall  
	jr $ra
	
leitura:
	move $t0, $a0
	move $t1, $t0
	li $t2, 0
l:	
	printS("Insira o valor de Vet[")
	move $a0, $t2
	li $v0, 1
	syscall
	printS("] ")
	li $v0, 5
	syscall
	sw $v0, ($t1)
	add $t1, $t1, 4
	addi $t2, $t2, 1
	blt $t2, $s0, l
	move $v0, $t0
	jr $ra
	
trocar:
	sw $t8, ($t9)
	sw $t7, ($t1)
	move $v0, $t0
	move $a0, $v0	
	
ordenar:
	move $t0, $a0
	move $t1, $t0
	sub $s1, $s0, 1
	li $t2, 0
o:	
	lw $a0, ($t1)
	add $t7, $zero, $a0 #t8 = V[i]
	add $t9, $zero, $t1 #t9 = endereco de V[i]
	add $t1, $t1, 4
	addi $t2, $t2, 1
	lw $t8, ($t1) #s1 = V[i+1] i < 5
	blt $t8, $t7, trocar
	blt $t2, $s1, o	
   	move $v0, $t0
	jr $ra	
	
escritaPrimeiros:
	move $t0, $a0
	move $t1, $t0
	li $t2, 0
	srl $s1, $s0, 1
	printS("N primeiros ordenados: ")
eP: 
	lw $a0, ($t1)
   	li $v0, 1
   	syscall
   	li $a0, 32
   	li $v0, 11
   	syscall
   	add $t1, $t1, 4
   	addi $t2, $t2, 1
   	blt $t2, $s1, eP
   	printS("\n")
   	move $v0, $t0
   	jr $ra	
   	
escritaUltimos:
	move $t0, $a0
	move $t1, $t0
	sub $s1, $s0, 1
	sll $t2, $s1, 2
	add $t1, $t1, $t2
	li $t2, 0
	srl $s1, $s0, 1
	printS("N ultimos ordenados (ao contrario): ")
eU: 
	lw $a0, ($t1)
   	li $v0, 1
   	syscall
   	li $a0, 32
   	li $v0, 11
   	syscall
   	sub  $t1, $t1, 4
   	addi $t2, $t2, 1
   	blt $t2, $s1, eU
   	printS("\n")
   	move $v0, $t0
   	jr $ra
