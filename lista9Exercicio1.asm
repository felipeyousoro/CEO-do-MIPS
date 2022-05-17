.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
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
			readInt()
			sw $v0, ($t0)
			add $t0, $t0, 4
			add $t1, $t1, 1
			blt $t1, %size, loop
		end:
.end_macro

.macro memcopy(%addressFrom, %addressTo, %size)
	.data
		currentIndex: .word 0
	.text
		main:
			li $t1, 0
		loop:
			lw $t0, currentIndex
			add $t1, $t0, %addressTo
			add $t0, $t0, %addressFrom
			lb $t0, ($t0) #conteudo aberto
			sb $t0, ($t1) #conteudo guardado
			lw $t0, currentIndex
			add $t0, $t0, 1
			sw $t0, currentIndex
			blt $t0, %size, loop
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

.macro printIntVector(%address, %size)
	.text
		main:
			li $t0, 0
			move $t1, %address
		loop:
			lw $v0, ($t1)
			printInt($v0)
			printString(" ")
			add $t0, $t0 1
			add $t1, $t1 4
			blt $t0, %size loop	
		end:
.end_macro

.text
	main:
		jal readNumber
		sll $t0, $s0 2
		alloc($t0)
		move $s1, $v0
		alloc($t0)
		move $s2, $v0
		readIntVector($s1, $s0)
		sll $s3, $s0, 2
		memcopy($s1, $s2, $s3)
		invertIntVector($s2, $s0)
		printIntVector($s2, $s0)
		end()
		
	readNumber:
		printString("Insira o valor de N: ")
		readInt()
		move $s0, $v0
		jr $ra