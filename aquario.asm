.data
    titulo:         .asciiz "\n========== AQUARIO INTELIGENTE ==========\n"
    linha:          .asciiz "==========================================\n"
    menu_opcoes:    .asciiz "\n1. Ler sensores manualmente\n2. Modo automatico\n3. Ver historico de temperatura\n4. Ver indice de qualidade\n5. Situacao atual\n0. Sair\n\nEscolha: "
    
    msg_temp:       .asciiz "Temperatura (20-35 C): "
    msg_ph:         .asciiz "pH (0-14): "
    msg_o2:         .asciiz "Oxigenio (0-15 mg/L): "
    msg_luz:        .asciiz "Luminosidade (0-100%): "
    
    status_ok:      .asciiz "[OK]     "
    status_atencao: .asciiz "[ATENCAO]"
    status_critico: .asciiz "[CRITICO]"
    
    msg_aquecedor:  .asciiz "AQUECEDOR: "
    msg_aerador:    .asciiz "AERADOR: "
    msg_luz_atu:    .asciiz "ILUMINACAO: "
    msg_on:         .asciiz "ON  "
    msg_off:        .asciiz "OFF "
    
    erro_opcao:     .asciiz "\nOpcao invalida! Tente novamente.\n"
    erro_valor:     .asciiz "\nValor fora do range! Tente novamente.\n"
    
    temp_atual:     .float 26.0      
    ph_atual:       .float 7.0    
    o2_atual:       .float 6.5       
    luz_atual:      .word 50       
    
    temp_min:       .float 24.0
    temp_max:       .float 28.0
    ph_min:         .float 6.5
    ph_max:         .float 8.0
    o2_min:         .float 5.0
    luz_min:        .word 30
    luz_max:        .word 70
    
    historico_temp: .space 40
    indice_hist:    .word 0          
    total_leituras: .word 0          
    
    estado_aquecedor: .byte 0
    estado_aerador:   .byte 0
    estado_luz:       .byte 1
    estado_alimentador: .byte 1
    
    qualidade_agua: .word 0          
    newline:        .asciiz "\n"
    espaco:         .asciiz " "

    msg_temp_label: .asciiz "TEMP: "
    msg_ph_label: .asciiz "ph:     "
    msg_o2_label: .asciiz "O2:     "
    msg_luz_label: .asciiz "LUZ:   "
    msg_graus: .asciiz " C "
    msg_mgl: .asciiz " mg/L "
    msg_percent: .asciiz "% "  

    alerta_temp_baixa: .asciiz "\n ALERTA: Temperatura baixa! Peixes lentos! \n"
    alerta_temp_alta: .asciiz "\n ALERTA: Temperatura alta! Risco de estresse termico.\n"
    alerta_ph_baixo: .asciiz "\n ALERTA: pH muito acido! Risco de vida para os peixes. \n"
    alerta_ph_alto: .asciiz "\n ALERTA: pH muito alcalino! Risco de vida para os peixes. \n"
    alerta_o2_baixo: .asciiz "\n ALERTA: Oxigenio em estado critico! Peixes podem ficar sem respirar.\n"
    alerta_luz_baixa: .asciiz "\n ALERTA: Luminosidade baixa! Vegetação do aquario comprometida. \n"
    alerta_luz_alta: .asciiz "\n ALERTA: Luminosidade alta! Risco de algas. \n"

    msg_historico_titulo: .asciiz "\n===== HISTORICO DE TEMPERATURA =====\n"
    msg_historico_vazio:  .asciiz "Nenhuma leitura registrada ainda.\n"
    msg_leitura:          .asciiz "Leitura "
    msg_doispontos:       .asciiz ": "
    msg_graus_c:          .asciiz " C\n"

    msg_qualidade_titulo: .asciiz "\n===== INDICE DE QUALIDADE =====\n"
    msg_qualidade_valor:  .asciiz "Qualidade da agua: "
    msg_qualidade_pts:    .asciiz "/100 pontos\n"
    msg_qualidade_otima:  .asciiz "Estado: OTIMO - Agua perfeita!\n"
    msg_qualidade_boa:    .asciiz "Estado: BOM - Agua adequada.\n"
    msg_qualidade_regular:.asciiz "Estado: REGULAR - Atencao necessaria.\n"
    msg_qualidade_ruim:   .asciiz "Estado: RUIM - Acao imediata!\n"

    msg_media_movel:    .asciiz "\nMedia Movel: "
    msg_tendencia:      .asciiz "Tendencia: "
    msg_subindo:        .asciiz "SUBINDO\n"
    msg_descendo:       .asciiz "DESCENDO\n"
    msg_estavel:        .asciiz "ESTAVEL\n"
    media_movel_valor:  .float 0.0

    msg_auto_titulo:    .asciiz "\n===== MODO AUTOMATICO =====\n"
    msg_auto_iter:      .asciiz "Quantas leituras automaticas? (1-10): "
    msg_auto_rodando:   .asciiz "\n--- Leitura automatica "
    msg_auto_de:        .asciiz " ---\n"
    msg_auto_fim:       .asciiz "\n===== FIM DO MODO AUTOMATICO =====\n"
    contador_auto:      .word 0
    temp_simulada:      .float 25.0
    variacao:           .float 0.5

    msg_log_titulo:     .asciiz "\n========== SITUACAO ATUAL ==========\n"
    msg_log_estado:     .asciiz "\n--- Estado Atual ---\n"
    msg_log_temp:       .asciiz "Temperatura: "
    msg_log_ph:         .asciiz "pH: "
    msg_log_o2:         .asciiz "Oxigenio: "
    msg_log_luz:        .asciiz "Luminosidade: "
    msg_log_atuadores:  .asciiz "\n--- Atuadores ---\n"
    msg_log_stats:      .asciiz "\n--- Estatisticas ---\n"
    msg_log_total:      .asciiz "Total de leituras: "
    msg_log_qualidade:  .asciiz "Qualidade atual: "
    msg_log_fim:        .asciiz "\n===================================\n"
    


.text
.globl main


main:
    addi $sp, $sp, -4  #inicialização na reserva de 4 para guardar o endereço de volta
    sw $ra, 0($sp)
    
menu_loop:
    li $v0, 4
    la $a0, titulo
    syscall
    
    li $v0, 4
    la $a0, menu_opcoes
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0         
    
    beq $t0, 0, sair_programa
    beq $t0, 1, opcao_ler_sensores
    beq $t0, 2, opcao_modo_automatico
    beq $t0, 3, opcao_historico
    beq $t0, 4, opcao_qualidade
    beq $t0, 5, opcao_exportar
    
    li $v0, 4
    la $a0, erro_opcao
    syscall
    j menu_loop

opcao_ler_sensores:
    jal ler_sensores  
    jal exibir_interface
    jal verificar_alertas
    jal controlar_atuadores
    j menu_loop

opcao_modo_automatico:
    addi $sp, $sp, -4
    sw $ra, 0($sp) 

    li $v0, 4
    la $a0, msg_auto_titulo
    syscall


    li $v0, 4
    la $a0, msg_auto_iter 
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    li $t0, 1
    blt $s1, $t0, fim_auto 
    
    li $t0, 10
    bgt $s1, $t0, fim_auto 

    li $s0, 0
    l.s $f20, temp_simulada 

    li $t0, 30
    sw $t0, luz_atual

loop_auto:
    bge $s0, $s1, fim_auto #registradores de s salvam e persistem em outras funções

    addi $s0, $s0, 1 

    li $v0, 4
    la $a0, msg_auto_rodando
    syscall
    move $a0, $s0
    li $v0, 1
    syscall



    li $v0, 4
    la $a0, msg_auto_de
    syscall

    s.s $f20, temp_atual
    
    li.s $f22, 7.0
    l.s $f26, variacao
    add.s $f22, $f22, $f26
    s.s $f22, ph_atual
    
    li.s $f22, 6.0
    sub.s $f22, $f22, $f26
    s.s $f22, o2_atual
    
    lw $t0, luz_atual
    addi $t0, $t0, 5
    li $t1, 80
    blt $t0, $t1, salvar_luz
    li $t0, 30

salvar_luz:
    sw $t0, luz_atual
    
    jal adicionar_ao_historico
    jal exibir_interface
    jal verificar_alertas
    jal controlar_atuadores
    jal calcular_qualidade
    jal exibir_qualidade

    l.s $f22, variacao
    add.s $f20, $f20, $f22

    li.s $f24, 30.0
    c.lt.s $f24, $f20
    bc1t inverter_variacao
    
    li.s $f24, 22.0
    c.lt.s $f20, $f24
    bc1t inverter_variacao

    j loop_auto

inverter_variacao: 
    l.s $f22, variacao
    neg.s $f22, $f22
    s.s $f22, variacao
    j loop_auto

fim_auto:
    li $v0, 4
    la $a0 msg_auto_fim
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j menu_loop




opcao_historico:
    jal exibir_historico
    j menu_loop

opcao_qualidade:
    jal calcular_qualidade
    jal exibir_qualidade
    j menu_loop

opcao_exportar:
    jal exportar_log
    j menu_loop

sair_programa:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    li $v0, 10
    syscall

ler_sensores:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, msg_temp
    syscall
    
    li $v0, 6
    syscall
    s.s $f0, temp_atual
    
    li $v0, 4
    la $a0, msg_ph
    syscall
    
    li $v0, 6
    syscall
    s.s $f0, ph_atual
    
    li $v0, 4
    la $a0, msg_o2
    syscall
    
    li $v0, 6
    syscall
    s.s $f0, o2_atual
    
    li $v0, 4
    la $a0, msg_luz
    syscall
    
    li $v0, 5
    syscall
    sw $v0, luz_atual
    
    jal adicionar_ao_historico
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

exibir_interface:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, linha
    syscall
    
    li $v0, 4
    la $a0, msg_temp_label
    syscall
    l.s $f12, temp_atual
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, msg_graus
    syscall

    l.s $f0, temp_atual
    l.s $f2, temp_min
    l.s $f4, temp_max
    c.lt.s $f0, $f2
    bc1t exibir_temp_critico
    c.lt.s $f4, $f0
    bc1t exibir_temp_critico
    j exibir_temp_ok
    
exibir_temp_critico:
    li $v0, 4
    la $a0, status_critico
    syscall
    j exibir_ph

exibir_temp_ok:
    li $v0, 4
    la $a0, status_ok
    syscall

exibir_ph:
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, msg_ph_label
    syscall

    l.s $f12, ph_atual
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, espaco
    syscall

    l.s $f0, ph_atual
    l.s $f2, ph_min
    l.s $f4, ph_max

    c.lt.s $f0, $f2
    bc1t exibir_ph_critico
    
    c.lt.s $f4, $f0
    bc1t exibir_ph_critico

    j exibir_ph_ok

exibir_ph_critico:
    li $v0, 4
    la $a0, status_critico
    syscall
    j exibir_o2

exibir_ph_ok:
    li $v0, 4
    la $a0, status_ok
    syscall

exibir_o2: 
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_o2_label
    syscall

    l.s $f12, o2_atual
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, msg_mgl
    syscall

    l.s $f0, o2_atual
    l.s $f2, o2_min
    c.lt.s $f0, $f2
    bc1t exibir_o2_critico
    j exibir_o2_ok

exibir_o2_critico:
    li $v0, 4
    la $a0, status_critico
    syscall
    j exibir_luz

exibir_o2_ok:
    li $v0, 4
    la $a0, status_ok
    syscall

exibir_luz:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_luz_label
    syscall

    lw $a0, luz_atual
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_percent
    syscall

    lw $t0, luz_atual
    lw $t1, luz_min
    lw $t2, luz_max

    blt $t0, $t1, exibir_luz_critico
    bgt $t0, $t2, exibir_luz_critico

    j exibir_luz_ok

exibir_luz_critico:
    li $v0, 4
    la $a0, status_critico
    syscall
    j exibir_atuadores

exibir_luz_ok:
    li $v0, 4
    la $a0, status_ok
    syscall

exibir_atuadores:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, linha
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

verificar_alertas:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    l.s $f0, temp_atual
    l.s $f2, temp_min
    l.s $f4, temp_max

    c.lt.s $f0, $f2
    bc1t alerta_temp_fria

    c.lt.s $f4, $f0
    bc1t alerta_temp_quente

    j verificar_ph_alerta

alerta_temp_fria:
    li $v0, 4
    la $a0, alerta_temp_baixa
    syscall
    j verificar_ph_alerta

alerta_temp_quente:
    li $v0, 4
    la $a0, alerta_temp_alta
    syscall

verificar_ph_alerta:
    l.s $f0, ph_atual
    l.s $f2, ph_min
    l.s $f4, ph_max

    c.lt.s $f0, $f2
    bc1t alerta_ph_acido
    
    c.lt.s $f4, $f0
    bc1t alerta_ph_basico

    j verificar_o2_alerta

alerta_ph_acido:
    li $v0, 4
    la $a0, alerta_ph_baixo
    syscall
    j verificar_o2_alerta

alerta_ph_basico:
    li $v0, 4
    la $a0, alerta_ph_baixo
    syscall

verificar_o2_alerta:
    l.s $f0, o2_atual
    l.s $f2, o2_min

    c.lt.s $f0, $f2
    bc1t alerta_o2_critico
    j verificar_luz_alerta

alerta_o2_critico:
    li $v0, 4
    la $a0, alerta_o2_baixo
    syscall

verificar_luz_alerta:
    lw $t0, luz_atual
    lw $t1, luz_min
    lw $t2, luz_max

    blt $t0, $t1, alerta_luz_pouca
    bgt $t0, $t2, alerta_luz_muita
    j fim_alertas

alerta_luz_pouca:
    li $v0, 4
    la $a0, alerta_luz_baixa
    syscall
    j fim_alertas

alerta_luz_muita:
    li $v0, 4
    la $a0, alerta_luz_alta
    syscall

fim_alertas:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

controlar_atuadores:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    l.s $f0, temp_atual
    l.s $f2, temp_min
    c.lt.s $f0, $f2
    bc1t ligar_aquecedor
    sb $zero, estado_aquecedor
    j verificar_aerador

ligar_aquecedor:
    li $t0, 1
    sb $t0, estado_aquecedor

verificar_aerador:
    l.s $f0, o2_atual
    l.s $f2, o2_min
    c.lt.s $f0, $f2
    bc1t ligar_aerador
    sb $zero, estado_aerador
    j verificar_luz_atu

ligar_aerador:
    li $t0, 1
    sb $t0, estado_aerador

verificar_luz_atu:
    lw $t0, luz_atual
    lw $t1, luz_min
    blt $t0, $t1, ligar_luz
    sb $zero, estado_luz
    j exibir_estados

ligar_luz:
    li $t0, 1
    sb $t0, estado_luz

exibir_estados:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_aquecedor
    syscall

    lb $t0, estado_aquecedor
    beq $t0, $zero, aquecedor_off
    
    li $v0, 4
    la $a0, msg_on
    syscall

    j mostrar_aerador

aquecedor_off:
    li $v0, 4
    la $a0, msg_off
    syscall

mostrar_aerador:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_aerador
    syscall

    lb $t0, estado_aerador
    beq $t0, $zero, aerador_off

    li $v0, 4
    la $a0, msg_on
    syscall

    j mostrar_luz_estado

aerador_off:
    li $v0, 4
    la $a0, msg_off
    syscall

mostrar_luz_estado:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_luz_atu
    syscall

    lb $t0, estado_luz
    beq $t0, $zero, luz_off

    li $v0, 4
    la $a0, msg_on
    syscall

    j fim_atuadores

luz_off:
    li $v0, 4
    la $a0, msg_off
    syscall

fim_atuadores:
    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra



adicionar_ao_historico:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, historico_temp
    lw $t1, indice_hist

    sll $t2, $t1, 2
    add $t0, $t0, $t2

    l.s $f0, temp_atual
    s.s $f0, 0($t0)

    addi $t1, $t1, 1
    li $t3, 10
    blt $t1, $t3, salvar_indice
    li $t1, 0

salvar_indice:
    sw $t1, indice_hist

    lw $t4, total_leituras
    addi $t4, $t4, 1
    sw $t4, total_leituras


    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

exibir_historico:
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, msg_historico_titulo
    syscall

    lw $t5, total_leituras
    beq $t5, $zero, historico_vazio

    li $t6, 10
    blt $t5, $t6, usar_total
    li $t5, 10

usar_total:
    la $t0, historico_temp
    li $t1, 0

loop_historico:
    bge $t1, $t5, mostrar_media

    li $v0, 4
    la $a0, msg_leitura
    syscall

    addi $a0, $t1, 1
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_doispontos
    syscall

    sll $t2, $t1, 2
    add $t3, $t0, $t2
    
    l.s $f12, 0($t3)

    li $v0, 2
    syscall

    li $v0, 4
    la $a0, msg_graus_c
    syscall

    addi $t1, $t1, 1
    j loop_historico

mostrar_media:
    jal calcular_media_movel
    
    li $v0, 4
    la $a0, msg_media_movel
    syscall
    
    l.s $f12, media_movel_valor
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, msg_graus_c
    syscall
    
    li $v0, 4
    la $a0, msg_tendencia
    syscall
    
    l.s $f0, temp_atual
    l.s $f2, media_movel_valor
    li.s $f6, 0.5
    sub.s $f4, $f0, $f2
    
    c.lt.s $f4, $f6
    bc1f tendencia_subindo
    
    li.s $f6, -0.5
    c.lt.s $f4, $f6
    bc1t tendencia_descendo
    
    li $v0, 4
    la $a0, msg_estavel
    syscall
    j fim_historico

tendencia_subindo:
    li $v0, 4
    la $a0, msg_subindo
    syscall
    j fim_historico

tendencia_descendo:
    li $v0, 4
    la $a0, msg_descendo
    syscall
    j fim_historico

fim_historico:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

historico_vazio:
    li $v0, 4
    la $a0, msg_historico_vazio
    syscall
    j fim_historico



calcular_media_movel:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t5, total_leituras
    beq $t5, $zero, media_zero

    li $t6, 10
    blt $t5, $t6, usar_total_media
    li $t5, 10

usar_total_media:
    la $t0, historico_temp
    li $t1, 0
    mtc1 $zero, $f4

soma_loop:
    bge $t1, $t5, calcular_divisao
    sll $t2, $t1, 2
    add $t3, $t0, $t2

    l.s $f6, 0($t3)
    add.s $f4, $f4, $f6
    addi $t1, $t1, 1
    j soma_loop

calcular_divisao:
    mtc1 $t5, $f8
    cvt.s.w $f8, $f8
    div.s $f4, $f4, $f8
    s.s $f4, media_movel_valor
    j fim_media_movel

media_zero:
    mtc1 $zero, $f4
    s.s $f4, media_movel_valor

fim_media_movel:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra



    
calcular_qualidade:
   addi $sp, $sp, -8
   sw $ra, 4($sp)
   sw $s0, 0($sp)
    
   li $s0, 0
    
   l.s $f0, temp_atual
   l.s $f2, temp_min
   l.s $f4, temp_max
   
   c.lt.s $f0, $f2
   bc1t pular_temp
   
   c.lt.s $f4, $f0
   bc1t pular_temp

   addi $s0, $s0, 25

pular_temp:
    l.s $f0, ph_atual
    l.s $f2, ph_min
    l.s $f4, ph_max

    c.lt.s $f0, $f2
    bc1t pular_ph

    c.lt.s $f4, $f0
    bc1t pular_ph

    addi $s0, $s0, 25

pular_ph:
    l.s $f0, o2_atual
    l.s $f2, o2_min
    
    c.lt.s $f0, $f2
    bc1t pular_o2

    addi $s0, $s0, 25

pular_o2:
    lw $t0, luz_atual
    lw $t1, luz_min
    lw $t2, luz_max

    blt $t0, $t1, pular_luz
    bgt $t0, $t2, pular_luz

    addi $s0, $s0, 25

pular_luz:
    sw $s0, qualidade_agua

    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    

exibir_qualidade:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, msg_qualidade_valor
    syscall

    lw $a0, qualidade_agua
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_qualidade_pts
    syscall

    lw $t0, qualidade_agua
    li $t1, 100
    
    beq $t0, $t1, qualidade_otima

    li $t1, 75
    
    bge $t0, $t1, qualidade_boa

    li $t1, 50

    bge $t0, $t1, qualidade_regular

    j qualidade_ruim

qualidade_otima:
    li $v0, 4
    la $a0, msg_qualidade_otima
    syscall
    j fim_qualidade

qualidade_boa:
    li $v0, 4
    la $a0, msg_qualidade_boa
    syscall
    j fim_qualidade

qualidade_regular:
    li $v0, 4
    la $a0, msg_qualidade_regular
    syscall
    j fim_qualidade

qualidade_ruim:
    li $v0, 4
    la $a0, msg_qualidade_ruim
    syscall
    j fim_qualidade

fim_qualidade:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


exportar_log:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, msg_log_titulo
    syscall
    
    li $v0, 4
    la $a0, msg_log_estado
    syscall
    
    li $v0, 4
    la $a0, msg_log_temp
    syscall
    l.s $f12, temp_atual
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, msg_graus_c
    syscall
    
    li $v0, 4
    la $a0, msg_log_ph
    syscall
    l.s $f12, ph_atual
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, msg_log_o2
    syscall
    l.s $f12, o2_atual
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, msg_mgl
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, msg_log_luz
    syscall
    lw $a0, luz_atual
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, msg_percent
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, msg_log_atuadores
    syscall
    
    li $v0, 4
    la $a0, msg_aquecedor
    syscall
    lb $t0, estado_aquecedor
    beq $t0, $zero, log_aquec_off
    li $v0, 4
    la $a0, msg_on
    syscall
    j log_mostrar_aerador
log_aquec_off:
    li $v0, 4
    la $a0, msg_off
    syscall

log_mostrar_aerador:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 4
    la $a0, msg_aerador
    syscall
    lb $t0, estado_aerador
    beq $t0, $zero, log_aer_off
    li $v0, 4
    la $a0, msg_on
    syscall
    j log_mostrar_luz
log_aer_off:
    li $v0, 4
    la $a0, msg_off
    syscall

log_mostrar_luz:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 4
    la $a0, msg_luz_atu
    syscall
    lb $t0, estado_luz
    beq $t0, $zero, log_luz_off
    li $v0, 4
    la $a0, msg_on
    syscall
    j log_stats
log_luz_off:
    li $v0, 4
    la $a0, msg_off
    syscall

log_stats:
    li $v0, 4
    la $a0, msg_log_stats
    syscall
    
    li $v0, 4
    la $a0, msg_log_total
    syscall
    lw $a0, total_leituras
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    jal calcular_qualidade
    
    li $v0, 4
    la $a0, msg_log_qualidade
    syscall
    lw $a0, qualidade_agua
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, msg_qualidade_pts
    syscall
    
    li $v0, 4
    la $a0, msg_log_fim
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
