.data 

.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
		li $v0, 4
		syscall
.end_macro

.macro printAddressString(%string)
	.text
		move $a0, %string
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

.macro end()
	.text
		li $v0, 10
		syscall
.end_macro

.macro strlenAddress(%string)
	.text
		main:
			li $t0, 0
			move $t1 %string
		loop:
			lb $t2, ($t1)
			beqz $t2, end
			add $t1, $t1, 1
			add $t0, $t0, 1
			j loop
		end:
			move $v0, $t0
.end_macro

.macro invertStringAddress(%string)
	.text
		main:
			move $a3 $v0
			strlenAddress(%string)
			move $v1 $v0
			move $v0 $a3
			sub $v1 $v1 1
			li $a0 0
			ble $v1 1 end
		loop:
			add $a1 $a0 %string
			lb $t0 ($a1)
			add $a2 $v1 %string
			lb $t1 ($a2)
			sb $t1 ($a1)
			sb $t0 ($a2)
			add $a0 $a0 1
			sub $v1 $v1 1
			bgt $v1 $a0 loop 				
		end:
.end_macro

.macro intToString(%int)
	.data 
		string: .word 16
	.text
		main:
			la $v0 string
			li $a0 10
			move $a1 %int
			blt $a1 $a0 end
		loop:
			div $a1 $a0
			mflo $a1
			mfhi $a2
			add $a2 $a2 48
			sb $a2 ($v0)
			add $v0 $v0 1
			bge $a1 $a0 loop # maior ou igual a 10
		end:
			add $a1 $a1 48
			sb $a1 ($v0)
			la $v0 string
			strlenAddress($v0)
			la $v0 string
			invertStringAddress($v0)
			la $v0 string
.end_macro

.text
	main:
		li $s7 112
		intToString($s7)
		move $t0 $v0
		printAddressString($t0)		
		end()
		
	
	
	
	
	
	
	
	