# 🧩 UFBA SUDOKU — Jogo em Verilog na DE2-115
### 🎮 Um Sudoku 100% digital, direto do FPGA para sua tela, com amor baiano e HDL na veia.

---

## 🔥 O que é isso?

Este é um projeto universitário desenvolvido por estudantes da **UFBA (Universidade Federal da Bahia)** que decidiram que Sudoku em Python é fácil demais.

**Então a gente fez em Verilog.**

🧠 Toda a lógica do jogo roda dentro do **FPGA (DE2-115 / Cyclone IV)**.  
🎮 Você joga com um **controle físico** (ex: Mega Drive).  
🖥️ A saída é exibida via **`pygame` rodando no PC**, lendo os dados do jogo enviados por **UART**.  

---

## ✨ Destaques

- ✅ Lógica de Sudoku 100% feita em **Verilog**
- ✅ Entrada via **controle universal** ou **controle de Mega Drive**
- ✅ Transmissão serial via **UART RS-232**
- ✅ Visualização e interação via **PC com `pygame`** (emula a "VGA")
- ✅ Mapas de Sudoku pré-carregados na memória
- ✅ Grid 9x9, com cursor, validações e preenchimento de células

---

## 🕹️ Como funciona?

### No FPGA (DE2-115):
- Lógica principal implementada em **HDL puro**
- Buffer de saída transmite estado do grid via UART
- Entrada do jogador lida diretamente via GPIO
- FSMs controlam movimentação, preenchimento e regras do Sudoku

### No PC:
- Um script em **Python com `pygame`**:
  - Lê continuamente os dados da UART
  - Renderiza o tabuleiro em tempo real
  - Interpreta comandos e atualizações enviadas pelo FPGA

---

## 🎯 Controles

| Ação             | Botão (controle) |
|------------------|------------------|
| Mover cursor     | Direcional       |
| Inserir número   | Botões 1–9       |
| Limpar célula    | Botão C          |
| Verificar solução| Botão Start      |
| Reiniciar        | Reset na placa   |

---

## 📷 Imagens do Projeto

> *(Adicione aqui fotos da placa rodando, a visualização no pygame, e a equipe durante os testes!)*

---

## 🛠️ Requisitos

### Hardware:
- 🧠 DE2-115 (FPGA Cyclone IV)
- 🕹️ Controle de Mega Drive ou universal
- 🔌 Cabo serial (UART USB↔TTL)
- 🖥️ PC com Linux ou Windows

### Software:
- Quartus II
- Python 3.x com:
  - `pygame`
  - `pyserial`

---

## ▶️ Como executar

### 1. No FPGA:
- Compile o projeto Verilog no Quartus
- Faça o upload via JTAG
- Conecte o cabo serial ao PC

### 2. No PC:
```bash
pip install -r requirements.txt
python3 visualizador_sudoku.py
