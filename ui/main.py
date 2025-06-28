import serial

porta = 'COM1'
baudrate = 115200

try:
    with serial.Serial(porta, baudrate, timeout=1) as ser:
        print(f"Lendo da porta {porta}... Pressione Ctrl+C para sair")

        while True:
            if ser.in_waiting > 0:
                byte_recebido = ser.read(1)  # Lê 1 byte
                print("Byte recebido: ", byte_recebido, "É um byte válido? ", isinstance(byte_recebido, bytes), "Tamanho: ", len(byte_recebido))
                try:
                    caractere = byte_recebido.decode('ascii')  # Converte para char
                    print(f"Recebido: '{caractere}' (hex: {byte_recebido.hex()})")
                except UnicodeDecodeError:
                    print(f"Byte inválido para ASCII: {byte_recebido.hex()}")

except serial.SerialException as e:
    print(f"Erro na porta serial: {e}")
except KeyboardInterrupt:
    print("\nLeitura encerrada pelo usuário.")
