.data 
	zeroFloat:  .float 0.0
	noveFloat: .float 9.0
	dezFloat: .float 10.0

.macro alloc(%size)
	.text
		move $a0, %size #movendo quantia para ser alocada
		li $v0, 9 #codigo para alocar memoria
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


.macro readFloat()
	.text
		li $v0, 6 #codigo pra ler float
		syscall #syscall
.end_macro

.macro printFloat(%float)
	.text
		mov.s $f12, %float #movendo numero a ser impresso
		li $v0, 2 #codigo para printar float
		syscall #syscall
.end_macro

.macro readFloatVector(%address, %size)
	.text
		main:
			li $t0 0 #carregando em t0 o index
			move $t1 %address #guardando em t1 o endereco do inicio
		loop: 	
			printString("Insira o valor de v[") #pedindo pro usuario escrever
			printInt($t0) #pedindo pro usuario escrever
			printString("]: ") #pedindo pro usuario escrever
			readFloat() #lendo float
			swc1 $f0 ($t1) #guardando float
			add $t0 $t0 1 #incrementando index
			add $t1 $t1 4 #incrementando posicao da memoria
			blt $t0 %size loop #verificando se terminou o loop
		end:
.end_macro

.text
	main:
		li $s0, 10 #tamanho do vetor
		sll $t0, $s0, 2 #tamanho do vetor em bytes para 10 floats
		alloc $t0 #alocando a memoria
		move $s1, $v0 #guardando em s1 o endereco
		readFloatVector $s1, $s0 #lendo o vetor
		jal media #calculando media
		jal desvioPadrao #calculando desvio padrao
		printFloat $f22 #printando dp
		end() #terminando o programa


	media:
		li $t0, 0 #carregando em t0 o index
		l.s $f12, zeroFloat #carregando em f12 o valor 0.0
		move $t1, $s1 #guardando em t1 o endereco do inicio

		loopMedia: 
			lwc1 $f0 ($t1) #carregando float
			add.s $f12, $f12, $f0 #somando os floats
			add $t0, $t0 1 #incrementando index
			add $t1, $t1 4 #incrementando posicao da memoria
			blt $t0 $s0 loopMedia #verificando se terminou o loop
			l.s $f2, dezFloat #carregando dez em float 
			div.s $f12, $f12, $f2 #dividindo os floats pelo dez
			mov.s $f20, $f12 #movendo media para f20
			jr $ra #retornando apos o calculo 

	desvioPadrao:
		li $t0, 0 #carregando em t0 o index
		move $t1, $s1 #guardando em t1 o endereco do inicio
		l.s $f12, zeroFloat #carregando em f12 o valor 0.0

		loopDesvioPadrao:
			lwc1 $f0 ($t1) #carregando float
			sub.s $f0, $f20, $f0 #v[i] - m
			mul.s $f0, $f0, $f0 #elevando ao quadrado
			add.s $f12, $f12, $f0 #somando
			add $t0, $t0 1 #incrementando index
			add $t1, $t1 4 #incrementando posicao da memoria
			blt $t0 $s0 loopDesvioPadrao #verificando se terminou o loop de somas
			l.s $f2, noveFloat #carregando nove em float
			div.s $f12, $f12, $f2 #dividindo os floats por n-1
			sqrt.s $f12, $f12 #raiz quadrada
			mov.s $f22, $f12 #movendo dp para f22
			jr $ra #retornando apos o calculo
