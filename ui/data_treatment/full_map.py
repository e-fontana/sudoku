import numpy as np

def decode_full_map(payload_bytes):
    """
    Recebe os dados do mapa completo e retorna uma lista de nibbles (0-15).
    """
    nibbles = []
    for byte in payload_bytes:
        high = (byte >> 4) & 0x0F  # bits mais significativos
        low = byte & 0x0F          # bits menos significativos
        nibbles.extend([high, low])

    # Pega apenas os 81 primeiros nibbles

    nibbles = nibbles[:81]

    full_map = np.array(nibbles, dtype=np.uint8).reshape((9, 9))
    
    return full_map