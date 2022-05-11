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

.macro isPrime(%int)
	.text
		main:
			li $a0 2
			move $a1 %int
			bne $a1 2 loop
			li $v0 1
			j end 
		loop:
			div $a1 $a0
			mfhi $a2
			beqz $a2 notPrime
			add $a0 $a0 1
			blt $a0 $a1 loop
			li $v0 1
			j end
		notPrime:
			li $v0 0
		end:		
.end_macro

.macro openFileWrite(%path)
	.data
		path: .asciiz %path
	.text
		la $a0, path
		li $a1, 1
		li $a2, 0
		li $v0, 13
		syscall
.end_macro

.macro strlen(%string)
	.data
		string: .asciiz %string
	.text
		main:
			li $t0, 0
			la $t1, string
		loop:
			lb $t2, ($t1)
			beqz $t2, end
			add $t1, $t1, 1
			add $t0, $t0, 1
			j loop
		end:
			move $v0, $t0
.end_macro

.macro strlenData(%data)
	.text
		main:
			li $t0, 0
			move $t1, %data
		loop:
			lb $t2, ($t1)
			beqz $t2, end
			add $t1, $t1, 1
			add $t0, $t0, 1
			j loop
		end:
			move $v0, $t0
.end_macro

.macro writeFileString(%file, %string)
	.data
		string: .asciiz %string
	.text
		move $a0, %file
		la $a1, string
		strlen(%string)
		move $a2, $v0
		li $v0, 15
		syscall
.end_macro

.macro writeFileData(%file, %data)
	.text
		move $a0, %file
		move $a1, %data
		strlenData(%data)
		move $a2, $v0
		li $v0, 15
		syscall
.end_macro

.macro closeFile(%file)
	.text
		move $a0, %file
		li $v0, 16
		syscall
.end_macro

.text
	main:
		readInt()
		move $s0 $v0
		sll $t0 $s0 2
		alloc($t0)
		move $s1 $v0
		jal fillWithPrimes
		end()
			
	fillWithPrimes:
		li $t0 2
		li $s2 0
		move $t1 $s1
		
		fillWithPrimesLoop:
			isPrime($t0)
			bne $v0 1 fillWithPrimesNext
			sw $t0 ($t1)
			add $t1 $t1 4
			add $s2 $s2 1
				fillWithPrimesNext:
			add $t0 $t0 1
			ble $t0 $s0 fillWithPrimesLoop
			jr $ra
			
	writeTwins:
		openFileWrite("gemeos.txt")
		move $t8 $v0 #arquivo
		li $v0 1
		alloc($v0)
		move $t9 $v0 #.word 
		move $t4 $s2 #size vetor
		move $t5 $s1 #primeiro elemento vetor
		li $t7 0
		writeTwinsLoop:
			lw $t2 ($t5)
			lw $t3 4($t5)
			sub $t3 $t3 $t2
			bgt $t3 2 writeTwinsNext
			add $t3 $t3 48
			sb $t3 ($t9)
			writeFileData($t9 $t8)
			writeFileString($t9 " ")
				writeTwinsNext:
			add $t5 $t5 4
			add $t7 $t7 1
			blt $t7 $t4 writeTwinsLoop
			closeFile($t8)
			jr $ra