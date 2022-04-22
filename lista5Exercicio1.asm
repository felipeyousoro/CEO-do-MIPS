.data
Mat: .space 256
strAux: .space 100

.macro printS(%str)
.data
macroS: .asciiz %str
.text
li $v0, 4
la $a0, macroS
syscall
.end_macro

.text
main:
	jal lerN
	la $a0, Mat
	jal leitura
	la $a0, Mat
	jal escrita
	li $v0, 10
	syscall
	
indice:
	mul $v0, $t0, $s0
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra

lerN:
	printS("Insira o valor de N: ")
	li $v0, 5
	syscall
	move $s0, $v0
	jr $ra
	
leitura:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
l:
	printS("Insira o valor[")
	move $a0, $t0
	li $v0, 1
	syscall
	printS("][")
	move $a0, $t1
	li $v0, 1
	syscall
	printS("]: ")
	#li $v0, 12  letura por chjar
	#syscall
	#move $t2, $v0
	#printS("\n")	
	la $a0, strAux
	li $a1, 100
	li $v0, 8
	syscall
	lb $t2, ($a0)
	####################### fim da leitura do valor
	jal indice
	sw $t2, ($v0) ########### valor guardad
	addi $t1, $t1, 1
	blt $t1, $s0, l  #se nao terminou a linha, continua (incrementa a coluna)
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $s0, l #se terminou a linha, parte para a proxima
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
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
	addi $a0, $a0, 3
	li $v0,  11
	syscall
	printS(" ")
	addi $t1, $t1, 1
	blt $t1, $s0, e   # se nao terminou a linha, continua (incrementa a coluna)
	printS("\n")
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $s0, e # se terminou a linha, parte para a proxima
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
