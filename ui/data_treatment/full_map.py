def decode_full_map(payload_bytes):
    """
    Recebe os dados do mapa completo e retorna uma lista de nibbles (0-15).
    """
    if len(payload_bytes) != 41:
        raise ValueError("O payload deve ter exatamente 41 bytes.")

    nibbles = []
    for byte in payload_bytes:
        high = (byte >> 4) & 0x0F  # bits mais significativos
        low = byte & 0x0F          # bits menos significativos
        nibbles.extend([high, low])

    # Pega apenas os 81 primeiros nibbles
    return nibbles[:81]