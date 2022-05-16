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

.text
	main:
		strlen("asfdasdas")
		printInt($v0)
		end()
