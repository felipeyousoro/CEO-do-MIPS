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

.macro readArray(%address, %nSize)
	.text
		rAMain:
			li $a2, 0 #m
			li $a3, 0 #n
		rALoop:
			arrayIndex(%address, %nSize, $a2, $a3)
			move $a1, $v0
			printString("Write a value:[")
			printInt($a2)
			printString("][")
			printInt($a3)
			printString("]: ")
			readInt()
			sw $v0, ($a1)
			addi $a3, $a3, 1
			blt $a3, %nSize, rALoop
			li $a3, 0
			addi $a2, $a2, 1
			blt $a2, %nSize, rALoop	
.end_macro

.macro arrayIndex(%aIArray, %aIColumnNumber, %aII, %aIJ)
	.text
		mul $v0, %aII, %aIColumnNumber #linhaAtual * nColunas
		add $v0, $v0, %aIJ #total + colunaAtual
		sll $v0, $v0, 2	 #total * 4
		add $v0, %aIArray, $v0 #total + endereco inicial	
.end_macro

.text
	main:
		jal readN
		mul $t0 $s2 $s2
		sll $t0 $t0 2
		alloc($t0)
		move $s0, $v0
		alloc($t0)
		move $s1, $v0
		
		
		readArray($s0 $s2)
		readArray($s1 $s2)
		
		jal positions
		
		printString("Numero de posicoes iguais: ")
		printInt($s3)
		printString("\n")
		printString("Soma posicoes: ")
		printInt($s4)
		printString("\n")
		end()
		
	readN:   ###### 
		printString("Write the value of N: ")
		readInt()
		move $s2, $v0
		jr $ra
		
	positions:
		li $t0 0
		li $t1 0
		li $t8 0 #quantidade de elementos
		li $t9 0 #soma posicoes
		positionsLoop:
			arrayIndex($s0, $s2, $t0, $t1)
			lw $t3 ($v0)
			arrayIndex($s1, $s2, $t0, $t1)
			lw $t4 ($v0)
			bne $t3 $t4 notEqual
			add $t8 $t8 1
			add $t9 $t9 $t0
			add $t9 $t9 1
			add $t9 $t9 $t1
			add $t9 $t9 1
				notEqual:
			add $t1 $t1 1
			blt $t1 $s2 positionsLoop
			li $t1 0
			add $t0 $t0 1
			blt $t0 $s2 positionsLoop
			move $s3 $t8
			move $s4 $t9
			jr $ra 