entrada = b'\xd8vT2\x1d\x00\xfe\xfa\xcf\xee\xbd\xae\xd8vT2\x1d\x00\xfe\xfa\xcf\xee\xbd\xae\xd8vT2\x1d\x00\xfe\xfa\xcf\xee\xbd\xae\xd0\x00\x00\x00\x00'

# Converte cada byte em 2 nibbles (4 bits)
nibbles = []
for byte in entrada:
    high = (byte >> 4) & 0x0F  # bits mais significativos
    low = byte & 0x0F          # bits menos significativos
    nibbles.extend([high, low])

# Pega apenas os 81 primeiros nibbles
nibbles = nibbles[:81]

# Exibe como lista de inteiros (0 a 15)
print("Lista de 81 nibbles:")
print(nibbles)

# Exibe em hexadecimal
print("\nHex:")
print(' '.join(f'{n:X}' for n in nibbles))
