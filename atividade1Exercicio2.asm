.macro readInt()
	.text
		li $v0, 5 #codigo para ler inteiro 
		syscall #syscall
.end_macro

.macro alloc(%size)
	.text
		move $a0, %size #movendo quantia para ser alocada
		li $v0, 9 #codigo para alocar memoria
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

.macro printStringBuffer(%buffer)
	.text
		move $a0, %buffer #movendo buffer da string
		li $v0, 4 #codigo para escrever string
		syscall #syscall
.end_macro

.macro strlenAddress(%string)
	.text
		main:
			li $t0, 0 #carregando em 0
			move $t1 %string #movendo buffer da string
		loop:
			lb $t2, ($t1) #carregando byte
 			beqz $t2, end #se o byte for 0, entao a string acabou, pula pro fim
			add $t1, $t1, 1 #caso a string nao tenha acabado, prosseguir para o proximo index
			add $t0, $t0, 1 #incrementando o tamanho
			j loop #voltando para o loop
		end:
			move $v0, $t0 #movendo para v0 o tamanho da string
.end_macro

.macro invertStringAddress(%string)
	.text
		main:
			move $a3 $v0 #movendo para evitar conflitos
			strlenAddress(%string) #calculando tamanho da string
			move $v1 $v0 #guardando tamanho da string em v1
			move $v0 $a3 #movendo de volta
			sub $v1 $v1 1 #subtraindo o tamanho da string em 1, pois o indice aqui inicia em 0
			li $a0 0 #carregando a0 com 1
			blt $v1 1 end #caso a string tenha tamanho igual a 1 entao nao precisa inverter
		loop:
			add $a1 $a0 %string #acessando endereco do byte pela frente
			lb $t0 ($a1) #carregando byte
			add $a2 $v1 %string #carregando endereco do byte por tras
			lb $t1 ($a2) #carregando byte
			sb $t1 ($a1) #guardando byte de tras na frente
			sb $t0 ($a2) #guardando byte da frente atras
			add $a0 $a0 1 #incrementando index da frente
			sub $v1 $v1 1 #subtraindo index por tras
			bgt $v1 $a0 loop #se os indexes de tras for maior que o da frente entao ja foi percorrido metade
					#do vetor e nao e necessario percorrer mais	
		end:
.end_macro

.macro intToString(%int)
	.data 
		string: .space 32 #string de retorno
	.text
		main:
			la $v0 string #carregando endereco da string
			li $a0 10 #carregando a0 em 10 para fazer as operacoes subsequentes
			move $a1 %int #movendo o inteiro para a1
			blt $a1 $a0 end #se o inteiro for menor que 10 entao ele so precisa fazer uma operacao para um inteiro unico
		loop:
			div $a1 $a0 #dividindo a1 por 10
			mflo $a1 #quociente em a1 (numero sem o inteiro final)
			mfhi $a2 #resto em a2 (o resto e o inteiro que procuramos)
			add $a2 $a2 48	#transformando de word para byte
			sb $a2 ($v0) #guardando no vetor da string
			add $v0 $v0 1 #incrementando index da string
			bge $a1 $a0 loop # maior ou igual a 10 continua
		end: #aqui as operacoes servem para inteiros menores que 10
			add $a1 $a1 48 #word para byte
			sb $a1 ($v0) #guardando no vetor da string
			la $v0 string #carregando endereco da string
			invertStringAddress($v0) #invertendo a string pois quando o procedimento e feito ela vem ao contrario
			la $v0 string #carregando endereco mais uma vez para retorno
.end_macro

.macro end()
	.text
		li $v0, 10 #codigo para fim do programa
		syscall #syscall
.end_macro

.macro memcopy(%addressFrom, %addressTo, %size)
	.data
		currentIndex: .word 0 #indice atual
	.text
		main:
			li $t1, 0 #carregando t0 com 0
		loop:
			lw $t0, currentIndex #carregando indice atual
			add $t1, $t0, %addressTo #guardando em t1 o indice que iremos guardar
			add $t0, $t0, %addressFrom #guardando em t0 o indice que iremos copiar
			lb $t0, ($t0) #conteudo aberto
			sb $t0, ($t1) #conteudo guardado
			lw $t0, currentIndex #carregando indice atual
			add $t0, $t0, 1 #incrementando
			sw $t0, currentIndex #guardando
			blt $t0, %size, loop #se for menor que o tamanho a ser copiado entao continuar
		end:
.end_macro

.text
	main:
		printString("Entre com o numero: ") #escrenvdo string
		readInt() #lendo inteiro 
		move $s0, $v0 #guardando o numero lindo em s0
		intToString($s0) #transformando o numero em string
		move $s1, $v0 #guardando a string em s1
		strlenAddress($s1) #calculando tamanho da string
		move $s2, $v0 #guardando o tamanho da string em s2
		alloc($s2) #alocando e copiando a string para outra e invertendo para comprar
		move $s3, $v0 #guardando o endereco em s3
		memcopy($s1, $s3, $s2) #copiando a string de s1 para s3
		invertStringAddress($s3) #invertendo a string em s3
		jal isPalindromo #verificando se e palindromo
		bnez $v0, sim #se for palindromo vai pular para escrever que e palindromo
		printString("O numero nao e palindromo\n") #escrevendo que nao e palindromo
		j fim #pulando para o fim
			sim: #label caso verdadro 
		printString("O numero e palindromo!\n") #escrevendo que e palindromo
			fim: #label para fim 
		end() #fim do programa
		
	isPalindromo:
		li $t0, 0 #carregando t0, que e o index
		move $t1, $s1 #movendo endereco da string
		move $t2, $s3 #movendo endereco da string invertida
		loop:
			lb $t3, ($t1) #carregando caractere em t3
			lb $t4, ($t2) #carregaando caractere em t4
			bne $t3, $t4, notPalindromo #se os numeros nao forem iguais entao nao e palindromo, pula para caso falso
			add $t0, $t0, 1 #incrementando index
			add $t1, $t1, 1 #incrementando index
			add $t2, $t2, 1 #incrementando index
			blt $t0, $s2, loop #se o index for menor que o tamanho, continua o loop
			li $v0, 1 #caso tenha terminado sem erros, entao e palindromo e carrega com 1
			jr $ra #retornando 
		notPalindromo: #label caso nao seja palindromo
			li $v0, 0 #caso nao seja palindromo, carrega com 0
			jr $ra	#retornando
		