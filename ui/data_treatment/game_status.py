from colors import Color

def decode_status(payload_bytes):
    """
    Recebe os dados do jogo e retorna um dicionário com o status atual.
    """

    payload_int = int.from_bytes(payload_bytes, 'big')

    shift_cores = 184 - 162
    cores = payload_int >> shift_cores

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

    colors = [Color[i] for i in decodificar_cores(cores_int=cores)]
    
    return {
        "colors": colors,
        "position": (pos_x, pos_y),
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