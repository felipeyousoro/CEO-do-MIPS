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

.macro closeFile(%file)
	.text
		move $a0, %file
		li $v0, 16
		syscall
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

.macro writeFile(%file, %string)
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

.text
	main:
		openFileWrite("nigga.txt")
		move $s0, $v0
		writeFile($s0, "bilu teteia")
		closeFile($s0)
		end()