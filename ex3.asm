.data
Mat: .space 64
Ent1: .asciiz " Insira o valor["
Ent2: .asciiz "]["
Ent3: .asciiz "]:"
Ent4: .asciiz " linhas\n"
Ent5: .asciiz " colunas\n"
Ent6: .asciiz " Escreva i e depois j:\n"
.text

############################

	# MUDAR PARA ALOCACAO DINAMICA
	# MUDAR PARA ALOCACAO DINAMICA

############################
main:
	jal lerIJ
	la $a0, Mat
	jal leitura
	la $a0, Mat
	jal calcularCol
	move $a0, $s0
	li $v0,  1
	syscall
	la $a0, Ent5
	li $v0, 4
	syscall
	la $a0, Mat
	jal calcularLin
	move $a0, $s0
	li $v0,  1
	syscall
	la $a0, Ent4
	li $v0, 4
	syscall
	li $v0, 10
	syscall

lerIJ:
	la $a0, Ent6
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a1, $v0
	li $v0, 5
	syscall
	move $a2, $v0
	jr $ra
	
indice: #$t0 = i, $t1, = j, $a1 e $a2 = n lin ou col
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3 #$v0 = indice e $a3 = end matriz
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

calcularCol:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
	li $s0, 0
	li $t0, 0
	li $t1, 0
cC:
	jal indice
	lw $a0, ($v0)
	bnez $a0, skipNext
	add $t0, $t0, 1
	blt $t0, $a1, cC
	add $s0, $s0, 1
	skipNext:
	add $t1, $t1, 1
	li $t0, 0
	blt $t1, $a2 cC
	lw $ra, ($sp)
	jr $ra
	
calcularLin:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
	li $s0, 0
	li $t0, 0
	li $t1, 0
cL:
	jal indice
	lw $a0, ($v0)
	bnez $a0, skipNext2
	add $t1, $t1, 1
	blt $t1, $a2, cL
	add $s0, $s0, 1
	skipNext2:
	add $t0, $t0, 1
	li $t1, 0
	blt $t0, $a1 cL
	lw $ra, ($sp)
	jr $ra