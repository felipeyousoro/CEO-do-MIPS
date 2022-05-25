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

.text
	main:
		printString("Entre com o numero: ") #escrevendo para entrar com inteiro
		readInt() #lendo inteiro
		move $s0, $v0 #guardando inteiro em s0
		jal isPerfect #verificando se e perfeito
		beq $v0, 1, sim #se for perfeito pula para para escrever que e perfeito
		printString("Nao e perfeito\n") #escrevendo nao e perfeito
		j fim #pulando para o fim
			sim: #label caso for perfeito 
		printString("O numero e perfeito!\n") #escrevendo que e perfeito
			fim: #label para o fim 
		end() #chamando fim do programa
		
	isPerfect:
		li $t0, 0 # soma dos divisores
		li $t1, 0 # resto da divisao (verificar se é diferente de 0)
		li $t2, 1 # numero
		bgt $s0, 1, loop #se o numero for igual a 1 entao e perfeito e nem precisa fazer o programa rodar
				#caso nao entao prossegue normalmente a partir de loop
		li $v0, 1 #carregando com 1 para indicar que o numero e perfeito (verdadeiro)
		jr $ra #retornando
		loop:
			rem $t1, $s0, $t2 #guardando em t1 o resto do numero que queremos saber se
						#e perfeito pelo numero atual
			bnez $t1, next #se o resto nao for 0 entao nao e divisor e pula para o proximo
			add $t0, $t0, $t2 #se for divisor entao soma na soma dos divisores
				next: #label para preparar o loop para ir para o proximo numero
			add $t2, $t2, 1 #incrementando proximo divisor
			blt $t2, $s0, loop #caso o divisor seja inferior ao numero que recebemos entao voltamos para o loop
			bne $t0, $s0, notPerfect #fim do loop e verificando se a soma dos divisores equivale ao numero que recebemos
			li $v0, 1 #carregando com 1 para indicar que o numero e perfeito
			j end #pulando para o fim
				notPerfect: #label para pular caso nao seja perfeito
			li $v0, 0 #carregando com 0 para indicar que o numero nao e perfeito
				end: #label para indicar o final
			jr $ra #retornando
	