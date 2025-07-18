from data_treatment.colors import Color
import numpy as np

def decode_status(payload_bytes) -> dict:
    # --- Extração dos campos usando máscaras e deslocamento de bits ---
    buffer_int = int.from_bytes(payload_bytes, 'big')
    # Padding: 5 bits [4:0]
    # Máscara: (1 << 5) - 1 == 0x1F
    padding = buffer_int & 0x1F
    
    # Time in Seconds: 11 bits [15:5]
    # Desloca 5 bits, aplica máscara de 11 bits.
    # Máscara: (1 << 11) - 1 == 0x7FF
    time_raw = (buffer_int >> 5) & 0x7FF # 0x7FF é a máscara para 11 bits
    
    # 2. Divide o valor de 11 bits em minutos e segundos.
    # Os 5 bits mais significativos são para minutos.
    # Para isolá-los, deslocamos os 6 bits dos segundos para fora.
    time_minutes = time_raw >> 6
    
    # Os 6 bits menos significativos são para segundos.
    # Para isolá-los, usamos uma máscara que captura apenas esses 6 bits.
    # Máscara para 6 bits: (1 << 6) - 1 == 63 == 0x3F
    time_seconds = time_raw & 0x3F
    
    # Selected Number: 4 bits [19:16]
    # Desloca 16 bits, aplica máscara de 4 bits.
    # Máscara: (1 << 4) - 1 == 0xF
    selected_number = (buffer_int >> 16) & 0xF
    
    # Errors: 2 bits [21:20]
    # Desloca 20 bits, aplica máscara de 2 bits.
    # Máscara: (1 << 2) - 1 == 0x3
    errors = (buffer_int >> 20) & 0x3
    
    # Position: 8 bits [29:22]
    # Desloca 22 bits, aplica máscara de 8 bits.
    # Máscara: (1 << 8) - 1 == 0xFF
    position_raw = (buffer_int >> 22) & 0xFF
    # Os 4 bits mais significativos são X
    position_x = position_raw >> 4
    # Os 4 bits menos significativos são Y
    position_y = position_raw & 0xF
    
    # Colors: 162 bits [191:30]
    # Desloca 30 bits, aplica máscara de 162 bits.
    # Máscara: (1 << 162) - 1
    colors_raw = (buffer_int >> 30) & ((1 << 162) - 1)
    
    colors_array = []
    # Itera 81 vezes para extrair 81 pares de bits
    for i in range(81):
        # Extrai os pares de bits do mais significativo para o menos significativo
        shift = 160 - (i * 2)
        color_value = (colors_raw >> shift) & 0x3 # Máscara 0b11 para pegar 2 bits
        colors_array.append(color_value)
    
    colors = [Color(i) for i in colors_array][::-1]
    colors = np.array(colors, dtype=Color).reshape((9, 9)).tolist()

    # --- Monta o dicionário de resultado ---
    decoded_data = {
        'colors': colors,
        'position': [position_x, position_y],
        'errors': errors,
        'selected_number': selected_number,
        'time': {
            'minutes': time_minutes,
            'seconds': time_seconds
        },
        'padding_value': padding
    }

    return decoded_data

def decodificar_cores(cores_int):
    """
    Recebe um inteiro de 162 bits e retorna uma lista com 81 índices de cor (0-3).
    """
    lista_de_cores_indices = []
    for i in range(81):
        shift_amount = 162 - (i + 1) * 2
        color_index = (cores_int >> shift_amount) & 3 # type: ignore
        lista_de_cores_indices.append(color_index)
    
    return lista_de_cores_indices