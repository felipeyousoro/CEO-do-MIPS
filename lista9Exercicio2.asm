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

.macro readInt()
	.text
		li $v0, 5
		syscall
.end_macro

.data

.macro pow(%x, %y)
	.text
		main:
			move $v0, %x
			move $t0, %y
			bgt $t0, 1, loop
			bnez $t0, end
			li $v0, 1
			j end
		loop:
			mul $v0, $v0, %x
			sub $t0, $t0, 1
			bgt $t0, 1, loop
		end:
.end_macro

.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.text
	main:
		jal readNumber
		pow($s0, $s1)
		move $s2, $v0
		printString("Total: ")
		printInt($s2)
		end()
			
		
	readNumber:
		printString("Insira o valor de K: ")
		readInt()
		move $s0, $v0
		printString("Insira o valor de N: ")
		readInt()	
		move $s1, $v0
		jr $ra
				
	
	
	
	
	
