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

.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.macro factorial(%n)
	.text
		main:
			li $t0, 1
			li $t1, 1
			bgt %n, 1, loop
			li $v0, 1
			j end
		loop:
			mul $t1, $t0, $t1
			add $t0, $t0, 1
			ble $t0, %n, loop
			move $v0, $t1
		end:
		
.end_macro

.macro powFloat(%x, %y)
	.data
		fpo: .float 1.0
	.text	
		main:
			mov.s $f0, %x
			bnez %y, notZero
			l.s $f0, fpo
			j end
				notZero:
			bne %y, 1, notOne
			mov.s $f0, %x
			j end
				notOne:
			li $t0, 1
		loop: 
			mul.s $f0, $f0, %x
			add $t0, $t0, 1
			blt $t0, %y, loop
		end:	
.end_macro

.macro cos(%x, %iterations)
	.data
		fpz: .float 0.0
		total: .float 1.0
		current: .word 1
	.text
		loop: 
			lw $t2, current
			mul $t3, $t2, 2
			powFloat %x, $t3
			mov.s $f1, $f0
			factorial $t3
			mtc1 $v0, $f0
			cvt.s.w $f0, $f0
			div.s $f0, $f1, $f0
			l.s $f1, total
			rem $t2, $t2, 2
			beq $t2, 1, skipOdd
			add.s $f0, $f0, $f1
			j next
				skipOdd:
			sub.s $f0, $f1, $f0
				next:
			s.s $f0, total
			lw $t0, current
			add $t0, $t0, 1
			sw $t0, current
			blt $t0, %iterations, loop
			l.s $f0, total
.end_macro

.text
	printString("Entre com X: ")
	readFloat()
	mov.s $f25, $f0
	printString("Entre com N: ")
	readInt()	
	move $s0, $v0 
	cos $f25, $s0
	printFloat($f0)
	end()