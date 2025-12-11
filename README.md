# Aquario Inteligente - Simulador IoT em MIPS

Projeto desenvolvido para a disciplina de Arquitetura e Organizacao de Computadores (UNIFESP - ICT).

Simulador de dispositivo embarcado/IoT que monitora e controla um aquario atraves de sensores e atuadores.

---

## Descricao do Projeto

O sistema simula um aquario inteligente com as seguintes capacidades:

- Leitura de sensores: temperatura, pH, oxigenio dissolvido e luminosidade
- Controle automatico de atuadores: aquecedor, aerador e iluminacao
- Monitoramento com alertas para valores criticos
- Historico de leituras com calculo de media movel
- Deteccao de tendencia (subindo/descendo/estavel)
- Indice de qualidade da agua (0-100 pontos)
- Modo automatico com simulacao de leituras

---

## Requisitos Tecnicos Atendidos

### 1. Minimo 3 funcoes alem da main

O projeto implementa 10 funcoes:

| Funcao | Descricao |
|--------|-----------|
| `ler_sensores` | Le valores dos sensores via entrada do usuario |
| `exibir_interface` | Mostra painel com valores e status |
| `verificar_alertas` | Exibe mensagens de alerta para valores criticos |
| `controlar_atuadores` | Liga/desliga equipamentos baseado em regras |
| `adicionar_ao_historico` | Armazena temperatura no buffer circular |
| `exibir_historico` | Mostra ultimas leituras de temperatura |
| `calcular_media_movel` | Calcula media das ultimas N temperaturas |
| `calcular_qualidade` | Calcula indice de qualidade (0-100) |
| `exibir_qualidade` | Mostra indice e classificacao |
| `exportar_log` | Exibe resumo completo do sistema |

### 2. Uso de pilha para salvar registradores

Todas as funcoes utilizam a pilha para preservar o endereco de retorno:

```asm
addi $sp, $sp, -4
sw $ra, 0($sp)
...
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra
```

A funcao `calcular_qualidade` tambem preserva o registrador `$s0`:

```asm
addi $sp, $sp, -8
sw $ra, 4($sp)
sw $s0, 0($sp)
...
lw $s0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
```

### 3. Uso de vetor

O historico de temperatura utiliza um vetor de 10 posicoes (buffer circular):

```asm
historico_temp: .space 40    # 10 floats x 4 bytes = 40 bytes
indice_hist:    .word 0      # indice atual no buffer
total_leituras: .word 0      # contador de leituras
```

O acesso ao vetor e feito com calculo de deslocamento:

```asm
sll $t2, $t1, 2      # multiplica indice por 4 (tamanho do float)
add $t0, $t0, $t2    # endereco = base + deslocamento
l.s $f0, 0($t0)      # carrega valor
```

### 4. Algoritmo nao trivial - Media Movel

O calculo da media movel soma as ultimas N temperaturas e divide pelo total:

```asm
calcular_media_movel:
    # Soma todas as leituras do historico
soma_loop:
    l.s $f6, 0($t3)          # carrega temperatura
    add.s $f4, $f4, $f6      # acumula soma
    addi $t1, $t1, 1
    j soma_loop

calcular_divisao:
    mtc1 $t5, $f8            # move contador para coprocessador
    cvt.s.w $f8, $f8         # converte para float
    div.s $f4, $f4, $f8      # media = soma / n
```

Alem da media, o sistema detecta tendencia comparando o valor atual com a media:

- Atual > Media + 0.5: SUBINDO
- Atual < Media - 0.5: DESCENDO
- Caso contrario: ESTAVEL

### 5. Interface ASCII

O sistema possui menu interativo e paineis formatados:

```
========== AQUARIO INTELIGENTE ==========

1. Ler sensores manualmente
2. Modo automatico
3. Ver historico de temperatura
4. Ver indice de qualidade
5. Situacao atual
0. Sair

==========================================
TEMP: 26.0 C [OK]
pH:   7.0 [OK]
O2:   6.5 mg/L [OK]
LUZ:  50% [OK]
==========================================

AQUECEDOR: OFF
AERADOR: OFF
ILUMINACAO: ON
```

---

## Regras de Controle Automatico

| Sensor | Condicao | Atuador | Acao |
|--------|----------|---------|------|
| Temperatura | < 24 C | Aquecedor | Liga |
| Temperatura | >= 24 C | Aquecedor | Desliga |
| Oxigenio | < 5 mg/L | Aerador | Liga |
| Oxigenio | >= 5 mg/L | Aerador | Desliga |
| Luminosidade | < 30% | Iluminacao | Liga |
| Luminosidade | >= 30% | Iluminacao | Desliga |

---

## Parametros dos Sensores

| Sensor | Minimo | Maximo | Unidade |
|--------|--------|--------|---------|
| Temperatura | 24 | 28 | Celsius |
| pH | 6.5 | 8.0 | - |
| Oxigenio | 5.0 | - | mg/L |
| Luminosidade | 30 | 70 | % |

---

## Indice de Qualidade

O indice varia de 0 a 100 pontos:

| Parametro OK | Pontos |
|--------------|--------|
| Temperatura dentro do range | +25 |
| pH dentro do range | +25 |
| Oxigenio acima do minimo | +25 |
| Luminosidade dentro do range | +25 |

Classificacao:

| Pontuacao | Estado |
|-----------|--------|
| 100 | OTIMO |
| 75-99 | BOM |
| 50-74 | REGULAR |
| 0-49 | RUIM |

---

## Como Executar

1. Instalar o SPIM:
```bash
brew install spim
```

2. Executar o programa:
```bash
spim -file aquario.asm
```

3. Ou usar o simulador MARS (requer Java):
   - Baixar em: https://courses.missouristate.edu/KenVollmar/MARS/
   - Abrir o arquivo `aquario.asm`
   - Clicar em "Assemble" e depois "Run"

---

## Estrutura do Codigo

```
aquario.asm
|
|-- .data
|   |-- Strings de interface
|   |-- Variaveis dos sensores (float/word)
|   |-- Limites min/max
|   |-- Vetor historico_temp
|   |-- Estados dos atuadores
|
|-- .text
    |-- main (menu principal)
    |-- ler_sensores
    |-- exibir_interface
    |-- verificar_alertas
    |-- controlar_atuadores
    |-- adicionar_ao_historico
    |-- exibir_historico
    |-- calcular_media_movel
    |-- calcular_qualidade
    |-- exibir_qualidade
    |-- exportar_log
```

---

## Registradores Utilizados

| Registrador | Uso |
|-------------|-----|
| $ra | Endereco de retorno |
| $sp | Ponteiro da pilha |
| $t0-$t6 | Valores temporarios |
| $s0, $s1 | Valores preservados entre chamadas |
| $f0-$f26 | Operacoes de ponto flutuante |
| $f12 | Argumento para syscall de impressao |

---

## Syscalls Utilizadas

| Codigo | Funcao |
|--------|--------|
| 1 | Imprimir inteiro |
| 2 | Imprimir float |
| 4 | Imprimir string |
| 5 | Ler inteiro |
| 6 | Ler float |
| 10 | Encerrar programa |

---

## Autores

Projeto desenvolvido para a disciplina de Arquitetura e Organizacao de Computadores.

UNIFESP - Instituto de Ciencia e Tecnologia

