.data

.macro printString(%string)
	.data
		string: .asciiz %string
	.text	
		la $a0, string
		li $v0, 4
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

.macro printInt(%int)
	.text	
		add $a0, $zero, %int		
		li $v0, 1
		syscall
.end_macro

.macro malloc(%size)
	.text
		add $a0, $zero, %size	
		li $v0, 9
		syscall
.end_macro

.macro createNode(%int)
	.text
		malloc(12)
		sw %int, 0($v0)
		sw $zero, 4($v0)
		sw $zero, 8($v0)
.end_macro

.macro insert(%treeAddress, %int)
	.data
		rootAddress: .space 4
	.text
		storeAddress:
			move $t0, %treeAddress
			sw $t0, rootAddress
			#subi $sp, $sp, 4
			#sw $t0, ($sp)
		insert:
			lw $t1, 0($t0)
			try:
				blt %int, $t1 tryLeft
				tryRight:
					lw $t1, 8($t0)
					bnez $t1, recRight
					createNode(%int)
					sw $v0, 8($t0) 
					j end
					recRight:
						lw $t0, 8($t0)
						j insert
				
				tryLeft:
					lw $t1, 4($t0)
					bnez $t1, recLeft
					createNode(%int)
					sw $v0, 4($t0)
					j end
					recLeft:
						lw $t0, 4($t0)
						j insert
				
		end:
.end_macro

.macro printTree(%treeAddress)
	.data
		rootAddress: .space 4
	.text
		main:
			move $t0, %treeAddress
			sw $t0, rootAddress
			subi $sp, $sp, 4
			sw $t0, ($sp)
			printString("----- PRINT RECURSIVO -----\n")
		printRecursive:
			lw $t1, 8($t0)
			beqz $t1, skipStoreRA
			subi $sp, $sp, 4
			sw $t1, ($sp) # right address
				skipStoreRA:
			lw $t1, 0($t0)
			printInt($t1)
			printString("\n")
			recLeft:
				lw $t0, 4($t0)
				bnez $t0, printRecursive
			recRight:
				lw $t0, ($sp)
				addi $sp, $sp, 4
				move $t1, $t0
				lw $t2, rootAddress
				bne $t1, $t2, printRecursive
				
		end:
.end_macro

.text
	main: 	
		readInt()
		move $s1, $v0
		createNode($s1)
		move $s0, $v0
		readInt()
		move $s1, $v0
		insert($s0, $s1)
		readInt()
		move $s1, $v0
		insert($s0, $s1)
		readInt()
		move $s1, $v0
		insert($s0, $s1)
		readInt()
		move $s1, $v0
		insert($s0, $s1)
		printTree($s0)
		end()
		
        
