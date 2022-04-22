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

.macro sortArray(%array, %size)
	.text
		main:
			move $t0, %array
			move $t1, %size
			move $t2, $t0
			li $t3, 0
			li $t4, 0
			li $t5, 0
		loop:
			lw $t4, ($t2)
			lw $t5, 4($t2)
			bgt $t4, $t5, swap
			add $t3, $t3, 1
			bge $t3, $t1, end
			add $t2, $t2, 4
			j loop
			swap:
				sw $t5, ($t2)
				sw $t4, 4($t2)
				li $t3, 0
				move $t2, $t0
				j loop
		end:
.end_macro


.macro printArrayAsc(%array, %size)
	.text
		main:
			move $t0, %array
			move $t1, %size
			li $t2, 0
			printString("[")
		loop:
			lw $v0, ($t0)
			printInt($v0)
			add $t0, $t0, 4
			add $t2, $t2, 1
			bgt $t2, $t1, end
			printString(", ")
			j loop	
		end:
			printString("]\n")
.end_macro

.text
	main:
		jal readN
		mul $t0 $s1 $s1
		sll $t0 $t0 2
		alloc($t0)
		move $s0, $v0
		
		readArray($s0 $s1)
		
		jal dadosSuperior
		jal dadosInferior
		
		printString("Maior elemento matriz superior: ")
		printInt($s2)
		printString("\n")
		printString("Maior elemento matriz inferior: ")
		printInt($s4)
		printString("\n")
		printString("Resultado da diferenca dos somatorios: ")
		sub $s6 $s3 $s4
		printInt($s6)
		printString("\n")
		
		mul $t9 $s1 $s1
		sub $t9 $t9 1
		sortArray($s0 $t9)
		printArrayAsc($s0 $t9)		
		
		end()
		
	readN:   ###### 
		printString("Write the value of N: ")
		readInt()
		move $s1, $v0
		jr $ra
			
	dadosSuperior:
		li $t0 0
		li $t1 0
		li $t2 -100
		li $t4 0
		loopSuperior:
			ble $t1 $t0 nextSuperior
			arrayIndex($s0, $s1, $t0, $t1)
			lw $t3 ($v0)
			add $t4 $t4 $t3
			blt $t3 $t2 nextSuperior
			move $t2 $t3
				nextSuperior:
			add $t1 $t1 1
			blt $t1 $s1 loopSuperior
			li $t1 0
			add $t0 $t0 1
			blt $t0 $s1 loopSuperior
			move $s2 $t2
			move $s3 $t4
			jr $ra
			
	dadosInferior:
		li $t0 0
		li $t1 0
		li $t2 -100
		li $t4 0
		loopInferior:
			ble $t0 $t1 nextInferior
			arrayIndex($s0, $s1, $t0, $t1)
			lw $t3 ($v0)
			add $t4 $t4 $t3
			blt $t3 $t2 nextInferior
			move $t2 $t3
				nextInferior:
			add $t1 $t1 1
			blt $t1 $s1 loopInferior
			li $t1 0
			add $t0 $t0 1
			blt $t0 $s1 loopInferior
			move $s4 $t2
			move $s5 $t4
			jr $ra
		
