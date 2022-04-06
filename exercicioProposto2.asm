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

.text
	main:
		openFileRead("data.txt")
		move $s0, $v0
		jal somaDados
		printString("SOMA: ")
		printInt($s1)
		closeFile($s0)
		end()
		
	somaDados:
		li $s1, 0
		li $s2, 0
		
		somaDadosLoop:
			getCharFile($s0)
			beqz $v0, skipEnd
			lb $a0, ($a0)
			beq $a0, 32, skipSpace
			subi $a0, $a0, 48
			mul $s2, $s2, 10
			add $s2, $s2, $a0
			j somaDadosLoop
				skipSpace:
					add $s1, $s1, $s2
					li $s2, 0
					j somaDadosLoop
				skipEnd:
					add $s1, $s1, $s2
			jr $ra
		
		
		
		
		
		
		