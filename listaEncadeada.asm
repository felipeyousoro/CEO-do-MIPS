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


.macro alloc(%size)
	.text
		move $a0, %size
		li $v0, 9
		syscall
.end_macro

.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.macro createList()
	.text 
		li $t0, 8
		alloc($t0)
.end_macro

.macro createNode(%data)
	.text
		li $t0, 8
		alloc($t0)
		sw %data, 4($v0)
.end_macro

.macro readInt()
	.text
		li $v0, 5
		syscall
.end_macro

.macro insertList(%list, %data) #head = 0, size = 4
	.data
		previousAddress: .word 0
	.text
		main:
			lw $t1, (%list)
			bnez $t1, loop
			createNode(%data)
			sw $v0, (%list)
			j end
		loop:
			sw $t1, previousAddress
	 		lw $t1, ($t1)
	 		bnez $t1, loop
	 		createNode(%data)
	 		lw $t1, previousAddress
	 		sw $v0, ($t1)
		end:
			lw $t1, 4(%list)
			add $t1, $t1, 1
			sw $t1, 4(%list)
.end_macro

.macro removeList(%list, %data)
	.data
		previousAddress: .word 0
		removeAddress: .word 0
	.text
		main:
			lw $t1, (%list)
			beqz $t1, end #lista vazia
			lw $t0, 4($t1)
			bne $t0, %data, loop #caso seja head
			lw $t0, ($t1)
			sw $t0, (%list)
			lw $t0, 4(%list) #decrementando size
	 		sub $t0, $t0, 1
	 		sw $t0, 4(%list)
			j end
		loop:
			sw $t1, previousAddress
	 		lw $t1, ($t1)
			beqz $t1, end 
	 		lw $t0, 4($t1)
	 		bne $t0, %data, loop
	 		sw $t1, removeAddress  #caso encontre, executa isso aqui
	 		lw $t0, previousAddress
	 		lw $t1, ($t1)
	 		sw $t1, ($t0)
	 		lw $t0, 4(%list) #decrementando size
	 		sub $t0, $t0, 1
	 		sw $t0, 4(%list)
		end:


.end_macro

.macro printList(%list)
	.text
		main:
			printString("Values: ")	
			lw $t0, (%list)
			beqz $t0, end
		loop:
			lw $t1, 4($t0)
			printInt($t1)
			lw $t0, ($t0)
			beqz $t0, end
			printString(", ")
			j loop
		end:
			printString("\n")
.end_macro

.text 
	main:
		createList()
		move $s0, $v0
		li $s1, 4
		#insertList($s0, $s1)
		#insertList($s0, $s1)
		#insertList($s0, $s1)
		#printList($s0)
		jal listLoop
		end()
		
		
	listLoop:
		printString("Inserir: 1\n")
		printString("Excluir: 2\n")
		printString("Consultar: 3\n")
		printString("Parar: 4\n")
		readInt()
		bge $v0, 4, skipLL
		bgt $v0, 1, tryRemove
		printString("Insira um valor para inserir: ")
		readInt()
		move $s1, $v0
		insertList($s0, $s1)
		j listLoop
			tryRemove:
		bgt $v0, 2, tryQuery
		printString("Insira um valor para remover: ")
		readInt()
		move $s1, $v0
		removeList($s0, $s1)
		j listLoop
			tryQuery:
		printList($s0)
		j listLoop
			skipLL:
		jr $ra