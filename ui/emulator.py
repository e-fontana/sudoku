
import serial
import time
import random

porta_serial_FPGA = "/dev/ttyUSB10"
baudrate = 115200
ser = serial.Serial(porta_serial_FPGA, baudrate)
time.sleep(2)

CORES = ["white", "blue", "yellow", "red"]

try:
    while True:
        # Gera tabuleiro aleatório
        numeros = [random.randint(0, 9) for _ in range(81)]
        cores = [random.randint(0, 3) for _ in range(81)]  # índices das cores

        # Gera posição aleatória do cursor
        linha_cursor = random.randint(0, 8)
        coluna_cursor = random.randint(0, 8)

        # Monta mensagem: números|cores|linha,coluna (FPGA deverá seguir essa ordem)
        msg = (
            ",".join(str(n) for n in numeros)
            + "|"
            + ",".join(str(c) for c in cores)
            + "|"
            + f"{linha_cursor},{coluna_cursor}"
        )

        ser.write((msg + "\n").encode("utf-8"))
        print("Enviado:", msg)
        time.sleep(5)

except KeyboardInterrupt:
    print("Encerrando emissor.")
    ser.close()
