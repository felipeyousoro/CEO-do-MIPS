#######################################################################################################################################
			############	############	############
			##		#		#	   #
			##		#		#	   #
			##		############    #	   #
			##		#		#	   #
			##		#		#  	   #
			############    ############	############
		
				###########	############
				#	   #	#	   #
				#	   #	#	   #
				#	   #	#	   #
				#	   #	#	   #
				#	   #	#	   #
				###########	############

		    ##		##     #     ##########     ##########
		    # ##      ## #     #     #        #	    #
		    #   ##  ##   #     #     #	      #	    #
		    #	  ##     #     #     ##########     ##########
		    #		 #     #     #			     #
		    #		 #     #     #			     #
		    #		 #     #     #		    ##########
						
#####################################################################################################################################

# By: Felipe Yousoro (based chad mito)

# Filosofia: Ultra economia de registradores, usando 
#	     apenas $t0 e $t1 como registradores temporários
#	     e $v0, $v1, $a0, $a1 e $a2 como retorno

# faltam:
# int to string
# string to int
# strlen buffer
# openfileread
# openfilewrite
# getchar
# getchar size
# writefile
# writefile buffer
# read int vector
# read int array (possivelmente incorporar vector como array)
# print int array
# sort int vector

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

.macro pow(%x, %y)
	.text
		main:
			move $v0, %x #isso nao vai contra a filosofia de 2 registradores
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

.macro memcopy(%addressFrom, %addressTo, %size)
	.data
		currentIndex: .word 0
	.text
		main:
			li $t1, 0
		loop:
			lw $t0, currentIndex
			add $t1, $t0, %addressTo
			add $t0, $t0, %addressFrom
			lb $t0, ($t0) #conteudo aberto
			sb $t0, ($t1) #conteudo guardado
			lw $t0, currentIndex
			add $t0, $t0, 1
			sw $t0, currentIndex
			blt $t0, %size, loop
		end:
.end_macro


.macro invertStringBuffer(%address, %size)
	.data
		firstHalf: .space 1
		lastHalf: .space 1
		currentIndex: .word 0
	.text
		main:
			blt %size, 2, end
		loop:
			lw $t0, currentIndex
			add $t0, $t0, %address
			lb $t0, ($t0)
			sb $t0, firstHalf #guardado primeiro
			lw $t1, currentIndex 
			sub $t1, %address, $t1
			sub $t1, $t1, 1
			add $t1, $t1, %size
			lb $t0, ($t1)
			sb $t0, lastHalf #guardado segundo
			lb $t0, firstHalf
			sb $t0, ($t1) #reescrito primeiro
			lw $t1, currentIndex
			add $t1, $t1, %address
			lb $t0, lastHalf
			sb $t0, ($t1) #reescrito segundo
			lw $t0, currentIndex #incremento
			add $t0, $t0, 1
			sw $t0, currentIndex
			sub $t1, %size, $t0
			blt $t0, $t1, loop
		end:
.end_macro

.macro invertIntVector(%address, %size)
	.data
		firstHalf: .space 4
		lastHalf: .space 4
		currentIndex: .word 0
	.text
		main:
			blt %size, 2, end
		loop:
			lw $t0, currentIndex
			sll $t0, $t0, 2
			add $t0, $t0, %address
			lw $t0, ($t0)
			sw $t0, firstHalf #guardado primeiro
			lw $t1, currentIndex 
			sub $t1, %size, $t1
			sll $t1, $t1, 2
			add $t1, $t1, %address
			sub $t1, $t1, 4
			lw $t0, ($t1)
			sw $t0, lastHalf #guardado segundo
			lw $t0, firstHalf
			sw $t0, ($t1) #reescrito primeiro
			lw $t1, currentIndex
			sll $t1, $t1, 2
			add $t1, $t1, %address
			lw $t0, lastHalf
			sw $t0, ($t1) #reescrito segundo
			lw $t0, currentIndex #incremento
			add $t0, $t0, 1
			sw $t0, currentIndex
			sub $t1, %size, $t0
			blt $t0, $t1, loop
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

.macro printIntVector(%address, %size)
	.text
		main:
			li $t0, 0
			move $t1, %address
		loop:
			lw $v0, ($t1) #vai contra a filosofia de 2 registradores, mas to com preguica de mudar
			printInt($v0)
			printString(" ")
			add $t0, $t0 1
			add $t1, $t1 4
			blt $t0, %size loop	
		end:
.end_macro

.text
	main:
		strlen("asfdasdas")
		printInt($v0)
		end()
