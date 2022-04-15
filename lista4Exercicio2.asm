.data

.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
		li $v0, 4
		syscall
.end_macro

.macro printInt(%int)
	.text
		move $a0, %int
		li $v0, 1
		syscall
.end_macro

.macro alloc(%aSize)
	.text
		add $a0, $zero, %aSize
		li $v0, 9
		syscall
.end_macro

.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.macro readInt()
	.text
		li $v0, 5
		syscall
.end_macro

.macro readArray(%rAArray, %rASize)
	.data
		info: .space 12
		address: .space 4
	.text
		rAMain:
			sw %rAArray, address
			lw $t4, address
			add $t5, $zero, %rASize
			li $t6, 0
			li $t7, 0
		rALoop:
			arrayIndex($t4, $t5, $t6, $t7)
			move $t9, $v0
			printString("Write a value:[")
			printInt($t6)
			printString("][")
			printInt($t7)
			printString("]: ")
			readInt()
			sw $v0, ($t9)
			addi $t7, $t7, 1
			blt $t7, $t5, rALoop
			li $t7, 0
			addi $t6, $t6, 1
			blt $t6, $t5, rALoop	
.end_macro

.macro arrayIndex(%aIArray, %aIColumnNumber, %aII, %aIJ)
	.text
		mul $v0, %aII, %aIColumnNumber #linhaAtual * nColunas
		add $v0, $v0, %aIJ #total + colunaAtual
		sll $v0, $v0, 2	 #total * 4
		add $v0, %aIArray, $v0 #total + endereco inicial	
.end_macro

.macro isColumnPerm(%arrayAddress, %i, %j)
	.text
		main:
			li $t6, 0 #contador de 1
			li $t7, 0 
			li $t8, 0
			li $t9, 0
		loop:
			arrayIndex(%arrayAddress, %j, $t8, $t9)
			lw $t7, ($v0)
			beqz $t7, nextLine
			bne $t7, 1, fail
			add $t6, $t6, 1
			bgt $t6, 1, fail
			nextLine:
				add $t8, $t8, 1
				blt $t8, %i, loop
			nextColumn:
				bne $t6, 1, fail 
				add $t9, $t9, 1
				li $t6, 0
				li $t8, 0
				blt $t9, %j, loop
				li $v0, 1
				j end
			fail:
				li $v0, 0
		end:
.end_macro		

.macro isLinePerm(%arrayAddress, %i, %j)
	.text
		main:
			li $t6, 0 #contador de 1
			li $t7, 0 
			li $t8, 0
			li $t9, 0
		loop:
			arrayIndex(%arrayAddress, %j, $t8, $t9)
			lw $t7, ($v0)
			beqz $t7, nextColumn
			bne $t7, 1, fail
			add $t6, $t6, 1
			bgt $t6, 1, fail
			nextColumn:
				add $t9, $t9, 1
				blt $t9, %j, loop
			nextLine:
				bne $t6, 1, fail 
				add $t8, $t8, 1
				li $t6, 0
				li $t9, 0
				blt $t8, %i, loop
				li $v0, 1
				j end
			fail:
				li $v0, 0
		end:
.end_macro

.macro isPermutation(%arrayAddress, %i, %j)
	.text
		main:
			isColumnPerm(%arrayAddress, %i, %j)
			beqz $v0, notPerm
			isLinePerm(%arrayAddress, %i, %j)
			beqz $v0, notPerm	
			printString("Is permutation")
			li $v0, 1
			j end
		notPerm:
			printString("Is not permutation")
			li $v0, 0
		end:		
		
.end_macro

.text
	main:
		jal readN
		alloc($s1)
		move $s0, $v0
		readArray($s0, $s1)
		isPermutation($s0, $s1, $s1)
		end()
		
	readN:   ###### 
		printString("Write the value of N: ")
		readInt()
		move $s1, $v0
		jr $ra
