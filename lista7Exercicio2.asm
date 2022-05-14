.data 

.macro printStringAddress(%string)
	.text
		move $a0, %string
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

.macro strlen(%string)
	.text
		main:
			li $t0, 0
			la $t1, (%string)
		loop:
			lb $t2, ($t1)
			beqz $t2, end
			add $t1, $t1, 1
			add $t0, $t0, 1
			j loop
		end:
			move $v0, $t0
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

.macro writeFileAddress(%file, %string)
	.text
		move $a0, %file
		move $a1, %string
		strlen(%string)
		move $a2, $v0
		li $v0, 15
		syscall
.end_macro

.macro encryptVowel(%charBuffer)
	.text
		move $a0 %charBuffer
		lb $a1 ($a0)
		li $a2 42
		blt $a1 65 notCaps
		bgt $a1 90 notCaps
		testeA:
		bne $a1 65 testeE
		sb $a2 ($a0)
		j end
		testeE: 
		bne $a1 69 testeI
		sb $a2 ($a0)
		j end
		testeI:
		bne $a1 73 testeO
		sb $a2 ($a0)
		j end
		testeO:
		bne $a1 79 testeU
		sb $a2 ($a0)
		j end
		testeU:
		bne $a1 85 end
		sb $a2 ($a0)
		j end
		notCaps:
		blt $a1 97 end
		bgt $a1 122 end
		testea:
		bne $a1 97 testee
		sb $a2 ($a0)
		j end
		testee: 
		bne $a1 101 testei
		sb $a2 ($a0)
		j end
		testei:
		bne $a1 105 testeo
		sb $a2 ($a0)
		j end
		testeo:
		bne $a1 111 testeu
		sb $a2 ($a0)
		j end
		testeu:
		bne $a1 117 end
		sb $a2 ($a0)
		end:
.end_macro

.text
	main:
	openFileRead("dados.txt")
	move $s0 $v0
	openFileWrite("dadossaida.txt")
	move $s1 $v0
	
	while:
	getCharFile($s0)
	move $s7 $v0
	beqz $v0 end
	move $s5 $a0
	encryptVowel($s5)
	writeFileAddress($s1 $s5)
	bnez $s7 while
	end:
	closeFile($s0)
	closeFile($s1)
	end()
		
