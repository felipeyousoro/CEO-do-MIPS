.data
Mat: .space 48
V: .space 12
Ent1: .asciiz " Insira o valor["
Ent2: .asciiz "]["
Ent3: .asciiz "]:"

.text
main:
	la $a0, Mat
	li $a1, 4
	li $a2, 3
	jal leitura
	la $a0, Mat
#	jal escrita
	####vetor e mult
	la $a0, V
	li $a1, 1
	li $a2, 3
	jal leitura
	la $a0, Mat
	jal multiplica
	###escreve matriz nova
	la $a0, Mat
	li $a1, 4
	li $a2, 3
	jal escrita
	li $v0, 10
	syscall
	
indice:
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra

leitura:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
l:
	la $a0, Ent1
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, Ent2
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, Ent3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t2, $v0
	jal indice
	sw $t2, ($v0)
	addi $t1, $t1, 1
	blt $t1, $a2, l
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, l
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

indiceV:
	la $t4, V 
	move $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $t4
	jr $ra
	
multiplica:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
	li $t0, 0
	li $t1, 0
	li $a1, 4
	li $a2, 3
m:
	jal indice
	lw $a0, ($v0)
	jal indiceV
	lw $t9, ($v0)
	mul $a0, $a0, $t9
	jal indice
	sw $a0, ($v0)
	add $t0, $t0, 1
	blt $t0, $a1, m 
	li $t0, 0
	add $t1, $t1, 1
	blt $t1, $a2, m
	lw $ra, ($sp)
	jr $ra
	
escrita:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
	li $t0, 0
	li $t1, 0
e:
	jal indice
	lw $a0, ($v0)
	li $v0,  1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	blt $t1, $a2, e
	la $a0, 10
	syscall
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, e
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
