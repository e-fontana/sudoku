import serial

# Configure a porta serial
ser = serial.Serial(
    port='/dev/ttyUSB0',         # substitua por sua porta, ex: '/dev/ttyUSB0' no Linux
    baudrate=115200,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=1  # 1 segundo de timeout para leitura
)

print("Esperando dados da UART...")

try:
    while True:
        byte = ser.read(1)  # lê um byte
        if byte:
            value = byte[0]
            print(f"Byte recebido: 0x{value:02X} {'✅ OK' if value == 0xAA else '❌ INCORRETO'}")
except KeyboardInterrupt:
    print("Interrompido pelo usuário.")
finally:
    ser.close()
