import serial

# Configure a porta serial
ser = serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=115200,
    timeout=1
)

memory_buffer = bytearray()

print("Esperando dados da UART...")

try:
    while True:
        byte = ser.read(1)  # lê um byte
        if byte:
            value = byte[0]
            print(f"Byte recebido: 0x{value:02X} {'✅ OK' if value == 0xAA else '❌ INCORRETO'}")
            if value == 0xAA:
                print("Início do pacote detectado, processando dados...")
                data = ser.read(10)
                print(f"Dados recebidos: {data.hex()}")
except KeyboardInterrupt:
    print("Interrompido pelo usuário.")
finally:
    ser.close()


arr = [{
    "visibily": True,
    "color": "black",
}]