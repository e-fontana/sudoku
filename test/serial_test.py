import serial
import time

def gerar_payload_hex(lista):
    if len(lista) != 81:
        raise ValueError("A lista precisa ter exatamente 81 elementos.")
    if any(not (0 <= v <= 9) for v in lista):
        raise ValueError("Todos os valores precisam ser entre 0 e 9.")
    
    # Converte a lista em uma string binária (4 bits por número)
    bits = ''.join(f'{v:04b}' for v in lista)
    
    # Adiciona 4 bits de padding no MSB
    bits = '0000' + bits  # Agora temos 328 bits
    
    # Converte para hexadecimal
    payload_int = int(bits, 2)
    payload_hex = f'{payload_int:082X}'  # 328 bits = 82 dígitos hexadecimais
    
    return payload_hex

def gerar_payload_184bits(colors, pos_x, pos_y, errors, selected_number):
    if len(colors) != 81:
        raise ValueError("colors deve ter 81 elementos.")
    if any(not (0 <= c <= 3) for c in colors):
        raise ValueError("colors deve conter apenas números entre 0 e 3.")
    if not (0 <= pos_x <= 15):
        raise ValueError("pos_x deve estar entre 0 e 15 (4 bits).")
    if not (0 <= pos_y <= 15):
        raise ValueError("pos_y deve estar entre 0 e 15 (4 bits).")
    if not (0 <= errors <= 3):
        raise ValueError("errors deve estar entre 0 e 3 (2 bits).")
    if not (0 <= selected_number <= 15):
        raise ValueError("selected_number deve estar entre 0 e 15 (4 bits).")

    bits = ''.join(f'{c:02b}' for c in colors)  # 162 bits
    bits += f'{pos_x:04b}'                      # 4 bits X
    bits += f'{pos_y:04b}'                      # 4 bits Y
    bits += f'{errors:02b}'                     # 2 bits
    bits += f'{selected_number:04b}'            # 4 bits
    bits += '0' * 8                             # padding 8 bits
    assert len(bits) == 184, f"Deu {len(bits)} bits, esperado 184."

    payload_int = int(bits, 2)
    payload_bytes = payload_int.to_bytes(23, 'big')  # 23 bytes

    return payload_bytes

def gerar_payload_vitoria(vitoria: bool, pontuacao: int) -> int:
    if not (0 <= pontuacao <= 127):
        raise ValueError("Pontuação deve estar entre 0 e 127.")
    
    bit_vitoria = 1 if vitoria else 0
    payload = (bit_vitoria << 7) | pontuacao
    return payload

test_map = [1, 2, 3, 4, 5, 6, 7, 8, 9] * 9
colors = [3] * 81  # 81 elementos
pos_x = 4
pos_y = 4
errors = 1
selected_number = 1

colors[9*4+4] = 0

ser = serial.Serial('/dev/pts/11', 9600)

print("Conectado à porta serial.")

print("Inicializando jogo...")
ser.write(b'\xAA')  # Início do jogo

time.sleep(1)  # Aguarda um segundo para garantir que o jogo esteja pronto
print("Alterando dificuldade...")
ser.write(b'\xAB\x01')  # Dificuldade (1 para True, 0 para False)
time.sleep(1)  # Aguarda um segundo para garantir que a mudança de dificuldade seja processada
ser.write(b'\xAB\x00')

print("Enviando mapa completo")  # Mapa completo
payload_hex = gerar_payload_hex(test_map)
payload_bytes = bytes.fromhex(payload_hex)
ser.write(b'\xAC' + payload_bytes)
print("Mapa enviado:", payload_hex)

print("Enviando estado atual do jogo")
time.sleep(1)
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, selected_number)
payload_bytes = payload_hex
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 1
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, selected_number)
payload_bytes = payload_hex
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 1
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 2)
payload_bytes = payload_hex
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 1
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 3)
payload_bytes = payload_hex
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 1
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 4)
payload_bytes = payload_hex
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 5)
payload_bytes = payload_hex
print(payload_bytes)
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 3
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 5)
payload_bytes = payload_hex
print(payload_bytes)
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
colors[9*4+4] = 3
payload_hex = gerar_payload_184bits(colors, pos_x, pos_y, errors, 5)
payload_bytes = payload_hex
print(payload_bytes)
ser.write(b'\xAD' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
payload_hex = gerar_payload_vitoria(True, 100)
print(f"Payload de vitória: {payload_hex:02X}")
payload_bytes = payload_hex.to_bytes(1, 'big')
print(payload_bytes)
ser.write(b'\xAE' + payload_bytes)
print("Estado do jogo enviado!")

time.sleep(1)
print("Inicializando jogo...")
ser.write(b'\xAA')  # Início do jogo

time.sleep(1)  # Aguarda um segundo para garantir que o jogo esteja pronto
print("Alterando dificuldade...")
ser.write(b'\xAB\x01')  # Dificuldade (1 para True, 0 para False)
time.sleep(1)  # Aguarda um segundo para garantir que a mudança de dificuldade seja processada
ser.write(b'\xAB\x00')

time.sleep(1)
payload_hex = gerar_payload_vitoria(False, 0)
print(f"Payload de vitória: {payload_hex:02X}")
payload_bytes = payload_hex.to_bytes(1, 'big')
print(payload_bytes)
ser.write(b'\xAE' + payload_bytes)
print("Estado do jogo enviado!")