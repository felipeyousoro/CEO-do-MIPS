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

.macro openFileRead(%path)
	.data
		path: .asciiz %path
	.text
		la $a0, path
		li $a1, 0
		li $v0, 13
		syscall
		blt $v0, $zero, fail
		j end
		fail:
			printString("Nao ha arquivo\n")
			li $v0, 0
		end:
.end_macro

.macro closeFile(%file)
	.text
		move $a0, %file
		li $v0, 16
		syscall
.end_macro

.macro getCharFile(%file)
	.data
		buffer: .space 1
	.text
		move $a0, %file
		la $a1, buffer
		li $a2, 1
		li $v0, 14
		syscall	
		move $a0, $a1
.end_macro

.macro getFileSize(%file)
	.text
		main:
			li $t0, 0
		loop:
			getCharFile(%file)
			addi $t0, $t0, 1
			bnez $v0, loop
			subi $t0, $t0, 1
			move $v0, $t0
.end_macro

.macro fileToArray(%file, %array, %size)
	.text
		main:
			move $t0, %file
			move $t1, %array
			move $t2, %size
			li $t4, 0
			li $t5, 0
			li $t6, 0
		loop:
			getCharFile($s0)
			beqz $v0, skipEnd
			lb $a0, ($a0)
			beq $a0, 32, skipSpace
			subi $a0, $a0, 48
			add $t4, $t4, $t5
			mul $t4, $t4, 10
			add $t5, $zero, $a0
			j loop
				skipSpace:
					add $t4, $t4, $t5
					sw $t4, ($t1)
					add $t1, $t1, 4
					li $t4, 0
					li $t5, 0
					add $t6, $t6, 1
					j loop
				skipEnd:
					add $t4, $t4, $t5
					sw $t4, ($t1)
			end:
				move $v0, $t6
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

.macro getEvenOdd(%array, %size)
	.text
		main:
			li $v0, 0
			li $v1, 0
			move $t0, %array
			move $t1, %size
			li $t2, 0
			li $t3, 0
		loop:
			lw $t2, ($t0)
			div $t2, $t2, 2
			mfhi $t2
			beq $t2, 1, odd
			add $v0, $v0, 1
			j next
			odd:
				add $v1, $v1, 1
			next:
				add $t0, $t0, 4
				add $t3, $t3, 1
				ble $t3, $t1, loop
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

.macro printArrayDesc(%array, %size)
	.text
		main:
			move $t0, %array
			move $t1, %size
			sll $t2, $t1, 2
			add $t0, $t0, $t2
			li $t2, 0
			printString("[")
		loop:
			lw $v0, ($t0)
			printInt($v0)
			sub $t0, $t0, 4
			add $t2, $t2, 1
			bgt $t2, $t1, end
			printString(", ")
			j loop	
		end:
			printString("]\n")
.end_macro

.text
	main:
		openFileRead("dados1.txt")
		move $s0, $v0
		getFileSize($s0)
		move $s1, $v0
		closeFile($s0)
		sll $t0, $s1, 2
		alloc($t0)
		move $s7, $v0

		printString("N de caracteres: ")
		move $t0, $s1
		printInt($t0)
		printString("\n")
				
		openFileRead("dados1.txt")
		move $s0, $v0
		fileToArray($s0, $s7, $s1)
		move $s1, $v0
		sortArray($s7, $s1)
		printString("Maior: ")
		sll $t0, $s1, 2
		add $t0, $t0, $s7
		lw $t0, ($t0)
		printInt($t0)
		printString("\n")
		printString("Menor: ")
		lw $t0, ($s7)
		printInt($t0)
		printString("\n")
		
		getEvenOdd($s7, $s1)
		move $t0, $v0
		move $t1, $v1
		printString("Quantia pares: ")
		printInt($t0)
		printString("\n")
		printString("Quantia impares: ")
		printInt($t1)
		printString("\n")		

		printString("Print crescente")		
		printArrayAsc($s7, $s1)
		printString("Print decrescente")		
		printArrayDesc($s7, $s1)
		
		end()
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
