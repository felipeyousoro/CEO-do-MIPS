.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
		li $v0, 4
		syscall
.end_macro

.macro printStringBuffer(%buffer)
	.text
		move $a0, %buffer
		li $v0, 4
		syscall
.end_macro

.macro readInt()
	.text
		li $v0, 5
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

.macro readIntVector(%address, %size)
	.text
		main:
			move $t0, %address
			li $t1, 0
		loop:
			printString("Vet[")
			printInt($t1)
			printString("]: ")
			readInt()
			sw $v0, ($t0)
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, %size, loop
		end:
.end_macro

.macro printIntVector(%address, %size)
	.text
		main:
			li $t0, 0
			move $t1, %address
		loop:
			lw $v0, ($t1) #vai contra a filosofia de 2 registradores, mas to com preguica de mudar
			printInt($v0)
			printString(" ")
			add $t0, $t0 1
			add $t1, $t1 4
			blt $t0, %size loop	
		end:
.end_macro

.macro invertIntVector(%address, %size)
	.data
		firstHalf: .space 4
		lastHalf: .space 4
		currentIndex: .word 0
	.text
		main:
			blt %size, 2, end
		loop:
			lw $t0, currentIndex
			sll $t0, $t0, 2
			add $t0, $t0, %address
			lw $t0, ($t0)
			sw $t0, firstHalf #guardado primeiro
			lw $t1, currentIndex 
			sub $t1, %size, $t1
			sll $t1, $t1, 2
			add $t1, $t1, %address
			sub $t1, $t1, 4
			lw $t0, ($t1)
			sw $t0, lastHalf #guardado segundo
			lw $t0, firstHalf
			sw $t0, ($t1) #reescrito primeiro
			lw $t1, currentIndex
			sll $t1, $t1, 2
			add $t1, $t1, %address
			lw $t0, lastHalf
			sw $t0, ($t1) #reescrito segundo
			lw $t0, currentIndex #incremento
			add $t0, $t0, 1
			sw $t0, currentIndex
			sub $t1, %size, $t0
			blt $t0, $t1, loop
		end:
.end_macro

.macro sortIntVector(%address, %size)
	.data
		currentIndex: .word 0
		currentValue: .word 0
		nextValue: .word 0
	.text
		main:
			ble %size, 1, end
		loop:
			lw $t0, currentIndex
			sll $t0, $t0, 2
			add $t0, $t0, %address
			lw $t1, ($t0)
			sw $t1, currentValue
			lw $t0, 4($t0)
			sw $t0, nextValue
			bge $t0, $t1, nextLoop
				swap: #t0 item de n+1 e t1 com n
			lw $t0, currentIndex
			sll $t0, $t0, 2
			add $t0, $t0, %address
			lw $t1, nextValue
			sw $t1, ($t0)
			lw $t1, currentValue
			sw $t1, 4($t0)
			li $t0, 0
			sw $t0, currentIndex
			j loop
				nextLoop:
			lw $t0, currentIndex
			add $t0, $t0, 1
			sw $t0, currentIndex
			add $t0, $t0, 1
			blt $t0, %size, loop
		end:
.end_macro

.text
	main:
		jal readN
		sll $s2, $s1, 2
		alloc($s2)
		move $s0, $v0
		readIntVector($s0, $s1) ##lendo vetor
		
		jal getVectorSum
		move $s3, $t3
		jal proc_menor_soma
		move $s3, $t3
		printString("Total de elementos menores que a soma: ")
		printInt($s3)
		printString("\n")
		
		jal proc_num_ímpar
		move $s3, $t3
		printString("Total de impares: ")
		printInt($s3)
		printString("\n")
		
		jal proc_prod_pos
		printString("Produto: ")
		printInt($s5)
		printString("\n")
		
		printString("Vetor Original: ")
		printIntVector($s0, $s1)
		printString("\n")
		jal proc_ord
		printString("Vetor Ordenado: ")
		printIntVector($s0, $s1)
		printString("\n")
		
		end()
		
	readN:
		printString("Entre com o numero de inteiros: ")
		readInt()
		move $s1, $v0
		jr $ra
		
		
	getVectorSum:
		loads: 
			move $t0, $s0
			li $t1, 0
			li $t3, 0
		loopGVS:
			lw $t2, ($t0)
			add $t3, $t3, $t2
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, $s1, loopGVS
			jr $ra
			
	proc_menor_soma:
		loads2: 
			move $t0, $s0
			li $t1, 0
			li $t3, 0
		loopGSLTT:
			lw $t2, ($t0)
			bge $t2, $s3, skipGSLTT
			add $t3, $t3, 1 
				skipGSLTT:
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, $s1, loopGSLTT
			jr $ra
			
	proc_num_ímpar:
		loads3: 
			move $t0, $s0
			li $t1, 0
			li $t3, 0
		loopGON:
			lw $t2, ($t0)
			div $t2, $t2, 2
			mfhi $t2
			blt $t2, 1, skipGON
			add $t3, $t3, 1 
				skipGON:
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, $s1, loopGON
			jr $ra
		
	proc_prod_pos:
		loads4: 
			move $t0, $s0
			li $t1, 0
			li $t3, 0 #index even
			li $t4, 99999 #even
			li $t5, 0 #index odd
			li $t6, 0 #odd
		loopGOGE:
			lw $t2, ($t0)
			div $t9, $t2, 2
			mfhi $t9
			blt $t9, 1, skipEven
			blt $t2, $t6, nextGOGE
			move $t6, $t2
			move $t5, $t1
			j nextGOGE
				skipEven:
			bgt $t2, $t4, nextGOGE
			move $t4, $t2
			move $t3, $t1
				nextGOGE:
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, $s1, loopGOGE
			move $s3, $t3
			move $s4, $t5
			mul $s5, $s3, $s4
			jr $ra
			
	proc_ord:
		sortIntVector($s0, $s1)
		invertIntVector($s0, $s1)
		jr $ra