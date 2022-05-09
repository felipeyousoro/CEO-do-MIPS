.data 

.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
		li $v0, 4
		syscall
.end_macro

.macro alloc(%size)
	.text
		add $a0, $zero, %size
		li $v0, 9
		syscall
.end_macro


.macro readInt()
	.text
		li $v0, 5
		syscall
.end_macro

.macro readFloat()
	.text
		li $v0, 6
		syscall
.end_macro

.macro printFloat(%float)
	.text
		mov.s $f12 %float
		li $v0 2
		syscall
.end_macro


.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.text
	main:
		#jal readN
		#sll $v0 $v0 2
		#alloc($v0)
		#move $t0 $v0
		readFloat()
		printFloat($f0)
		end()
	
	readN:   ###### 
		printString("Write the value of N: ")
		readInt()
		move $s2, $v0
		jr $ra