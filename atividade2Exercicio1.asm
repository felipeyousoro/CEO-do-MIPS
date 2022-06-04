.macro readInt()
	.text
		li $v0, 5 #codigo para ler inteiro 
		syscall #syscall
.end_macro

.macro printInt(%int)
	.text
		move $a0, %int #movendo o inteiro a ser escrito
		li $v0, 1 #codigo para escrever inteiro
		syscall #syscall
.end_macro


.macro printString(%string)
	.data
		string: .asciiz %string #string que sera escrita
	.text
		la $a0, string #carregando endereco da string
		li $v0, 4 #codigo para escrever string
		syscall #syscall
.end_macro

.macro end()
	.text
		li $v0, 10 #codigo para fim do programa
		syscall #syscall
.end_macro

.macro factorial(%n)
	.text
		main:
			li $t0, 1 #numero atual
			li $t1, 1 #total
			bgt %n, 1, loop #se o fatorial for 1 ou 0 nao faz o loop
			li $v0, 1 #ao inves de fazer o loop ele retornara 1
			j end #pulando para o final
		loop: 
			mul $t1, $t0, $t1 #multiplicando o atual pelo total
			add $t0, $t0, 1 #partindo para o proximo
			ble $t0, %n, loop #se nao terminou entao volta a fazer o loop
			move $v0, $t1 #guardando o total em v0 para voltar
		end:
		
.end_macro

.text 
	main:
		printString("Digite N: ") #lendo n
		readInt() #lendo n
		move $s0, $v0 #guardando n em s0
		printString("Digite P: ") #lendo p
		readInt() #lendo p
		move $s1, $v0 #guardando p em s1
		jal arranjo #pulando para o arranjo
		printInt($s4) #printando resultado
		end() #terminando programa
		
	arranjo:
		sub $s2, $s0, $s1 #n -p 
		factorial $s0 #fatorial de n
		move $s3, $v0 #guardando fatorial de n em s3
		factorial $s2 #fatorial de n-p
		move $s2, $v0 #guardando em t0 o fatorial de n-p
		div $s4, $s3, $s2 #fatorial de n dividido por fat de n-p guardado em s4
		jr $ra #retornando