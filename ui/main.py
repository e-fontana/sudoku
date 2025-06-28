import serial
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

porta = 'COM1'
baudrate = 115200

try:
    logging.info(f"Conectando à porta {porta} com baudrate {baudrate}...")
    with serial.Serial(porta, baudrate, timeout=1) as ser:
        logging.info(f"Lendo da porta {porta}... Pressione Ctrl+C para sair")

        while True:
            if ser.in_waiting > 0:
                byte_recebido = ser.read(1)  # Lê 1 byte
                logging.info(f"", "Byte recebido: ", byte_recebido, "É um byte válido? ", isinstance(byte_recebido, bytes), "Tamanho: ", len(byte_recebido))
                try:
                    caractere = byte_recebido.decode('ascii')  # Converte para char
                    logging.info(f"Recebido: '{caractere}' (hex: {byte_recebido.hex()})")
                except UnicodeDecodeError:
                    logging.warning(f"Byte inválido para ASCII: {byte_recebido.hex()}")

except serial.SerialException as e:
    logging.error(f"Erro na porta serial: {e}")
except KeyboardInterrupt:
    logging.warning("\nLeitura encerrada pelo usuário.")
