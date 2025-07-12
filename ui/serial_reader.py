import serial

ser = serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=115200,
    timeout=1
)

memory_buffer = bytearray()

event_list = {
    0xAA: "start",
    0xAB: "dificulty",
    0xAC: "full_map",
    0xAD: "visibility",
    0xAE: "end_game",
}

print("Esperando dados da UART...")
try:
    while True:
        byte = ser.read(1)  # lê um byte
        
        if not byte:
            continue
        
        if byte[0] in event_list:
            print(f"Evento detectado: {event_list[byte[0]]}")

        byte = ser.read(41)  # lê um byte
        for b in byte:
            memory_buffer.append(b)
        print(f"Byte recebido: {byte}")
        print(f"Buffer atual: {memory_buffer}")
        for byte in memory_buffer:
            print(f"Byte no buffer: {byte}")
        break
except KeyboardInterrupt:
    print("Interrompido pelo usuário.")
finally:
    ser.close()