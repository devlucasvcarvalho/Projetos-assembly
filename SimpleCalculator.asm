.data
    prompt1: .asciiz "Insira o primeiro número: "
    prompt2: .asciiz "Insira o segundo número: "
    prompt3: .asciiz "Escolha a operação (1: Soma, 2: Subtracao, 3: Multiplicacao, 4: Divisao): "
    result_msg: .asciiz "Resultado: "
    newline: .asciiz "\n"

.text
    .globl main

main:
    # Primeira mensagem: pedir o primeiro número
    li $v0, 4                # system call para imprimir string
    la $a0, prompt1          # carregar endereço da mensagem
    syscall                  # chamada do sistema
    
    # Leitura do primeiro número
    li $v0, 5                # system call para ler inteiro
    syscall
    move $t0, $v0            # armazena o primeiro número em $t0
    
    # Segunda mensagem: pedir o segundo número
    li $v0, 4
    la $a0, prompt2
    syscall
    
    # Leitura do segundo número
    li $v0, 5
    syscall
    move $t1, $v0            # armazena o segundo número em $t1
    
    # Mensagem para escolha da operação
    li $v0, 4
    la $a0, prompt3
    syscall
    
    # Leitura da escolha da operação
    li $v0, 5
    syscall
    move $t2, $v0            # armazena a operação escolhida em $t2
    
    # Realiza a operação com base na escolha
    beq $t2, 1, soma         # Se $t2 == 1, vai para soma
    beq $t2, 2, subtracao    # Se $t2 == 2, vai para subtracao
    beq $t2, 3, multiplicacao # Se $t2 == 3, vai para multiplicacao
    beq $t2, 4, divisao      # Se $t2 == 4, vai para divisao
    
    # Operação: Soma
soma:
    add $t3, $t0, $t1        # $t3 = $t0 + $t1
    j resultado              # Salta para a exibição do resultado

    # Operação: Subtração
subtracao:
    sub $t3, $t0, $t1        # $t3 = $t0 - $t1
    j resultado
    
    # Operação: Multiplicação
multiplicacao:
    mul $t3, $t0, $t1        # $t3 = $t0 * $t1
    j resultado

    # Operação: Divisão
divisao:
    beq $t1, $zero, erro_divisao # Evita divisão por zero
    div $t0, $t1            # $t0 = dividendo, $t1 = divisor
    mflo $t3                # Resultado da divisão em $t3
    j resultado

erro_divisao:
    li $v0, 4
    la $a0, newline
    syscall
    la $a0, "Erro: divisao por zero.\n"
    syscall
    j fim
    
# Exibe o resultado
resultado:
    li $v0, 4                # system call para imprimir string
    la $a0, result_msg       # Carrega a mensagem "Resultado: "
    syscall
    
    # Imprimir o valor do resultado ($t3)
    li $v0, 1                # system call para imprimir inteiro
    move $a0, $t3            # Coloca o resultado em $a0 para imprimir
    syscall

    # Nova linha
    li $v0, 4
    la $a0, newline
    syscall

fim:
    # Finalizar o programa
    li $v0, 10               # system call para encerrar o programa
    syscall
