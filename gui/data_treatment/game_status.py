from data_treatment.colors import Color
import numpy as np

def decode_status(payload_bytes):
    """
    Recebe os dados do jogo e retorna um dicionário com o status atual.
    """
    payload_int = int.from_bytes(payload_bytes, 'big')

    shift_cores = 184 - 162
    cores = payload_int >> shift_cores

    numero_int = int(cores)

    # Converte para binário (string) sem o '0b'
    binario_str = bin(numero_int)[2:].zfill(162)

    # Ajusta para múltiplo de 2 bits (com padding zeros à esquerda)
    if len(binario_str) % 2 != 0:
        binario_str = '0' + binario_str

    # Divide em grupos de 2 bits
    pares_de_bits = [binario_str[i:i+2] for i in range(0, len(binario_str), 2)]

    # Converte cada par para inteiro (0 a 3)
    indices = [int(par, 2) for par in pares_de_bits]

    shift_posicao = shift_cores - 8
    mask_posicao = 0xFF # Máscara de 8 bits (2^8 - 1)
    posicao_raw = (payload_int >> shift_posicao) & mask_posicao
    pos_x = (posicao_raw >> 4) & 0x0F
    pos_y = posicao_raw & 0x0F

    shift_erros = shift_posicao - 2
    mask_erros = 0x03 # Máscara de 2 bits (2^2 - 1)
    erros = (payload_int >> shift_erros) & mask_erros

    shift_numero = shift_erros - 4
    mask_numero = 0x0F # Máscara de 4 bits (2^4 - 1)
    numero_selecionado = (payload_int >> shift_numero) & mask_numero

    colors_array = [Color(i) for i in indices][::-1]

    colors = np.array(colors_array, dtype=Color).reshape((9, 9)).tolist()

    return {
        "colors": colors,
        "position": [pos_x, pos_y],
        "errors": erros,
        "selected_number": numero_selecionado
    }

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