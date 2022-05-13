.data 

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

.macro readFloat()
	.text
		li $v0, 6
		syscall
.end_macro

.macro printFloat(%float)
	.text
		mov.s $f12, %float
		li $v0, 2
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

.macro strlen(%string)
	.data
		string: .asciiz %string
		size: .word 0
	.text
		loop:
			la $t0, string
			la $t1, size
			lw $t1, ($t1)
			add $t0, $t0, $t1
			lb $t0, ($t0)
			beqz $t0, end
			add $t1, $t1, 1
			la $t0, size
			sw $t1, ($t0)
			j loop
		end:
			la $t0, size
			lw $t0, ($t0)
			move $v0, $t0
.end_macro

.text
	main:
		strlen("asfdasdas")
		printInt($v0)
		end()