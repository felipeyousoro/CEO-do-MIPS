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

.macro readFloatVector(%address, %size)
	.text
		main:
			li $t0 0
			move $t1 %address
		loop:
			readFloat()
			swc1 $f0 ($t1)
			add $t0 $t0 1
			add $t1 $t1 4
			blt $t0 %size loop	
		end:
.end_macro

.macro printFloatVector(%address, %size)
	.text
		main:
			li $t0 0
			move $t1 %address
		loop:
			lwc1 $f0 ($t1)
			printFloat($f0)
			printString(" ")
			add $t0 $t0 1
			add $t1 $t1 4
			blt $t0 %size loop	
		end:
.end_macro

.macro sortFloatVector(%address, %size)
	.data
		currentIndex: .space 4
	.text
		main:
			la $t0, currentIndex
			sw $zero, ($t0)
			ble %size, 1, end
		loop:
			move $t0, %address
			la $t1, currentIndex
			lw $t1, ($t1)
			sll $t1, $t1, 2
			add $t0, $t0, $t1 #t0 = [t0]
			lwc1 $f20, ($t0) 
			lwc1 $f22, 4($t0)
			c.lt.s $f22, $f20
			bc1f skip
			swap:
				swc1 $f22, ($t0)
				swc1 $f20, 4($t0)
				la $t0, currentIndex
				sw $zero, ($t0) #reset index
				j loop
				skip:
			la $t0, currentIndex
			move $t1, $t0
			lw $t0, ($t0)
			add $t0, $t0, 1 #incremento no index
			sw $t0, ($t1)
			add $t0, $t0, 1 #size inicia em 1, enquanto o index em 0, isso serve para compensar
			blt $t0, %size, loop
		end:

.end_macro

.text
	main:
		jal readN
		move $s1 $v0
		sll $v0 $v0 2
		alloc($v0)
		move $s0 $v0
		readFloatVector($s0 $s1)
		sortFloatVector($s0, $s1)
		printFloatVector($s0 $s1)
		end()
	
	readN:   ###### 
		printString("Write the value of N: ")
		readInt()
		move $s2, $v0
		jr $ra