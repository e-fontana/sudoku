import serial
from data_treatment import game_status, full_map
from screens import Modelo

EVENT_LIST = {
    0xAA: "start",
    0xAB: "dificulty",
    0xAC: "full_map",
    0xAD: "visibility",
    0xAE: "end_game",
}

class SerialReader:
    def __init__(self, model: Modelo, port = '/dev/ttyUSB0', baudrate = 115200):
        self.port = port
        self.baudrate = baudrate
        self.model = model

    def read_serial(self):
        """
        Lê a porta serial, sincroniza com o cabeçalho 'AD' (0x4144)
        e desempacota o payload de 192 bits.
        """
        try:
            ser = serial.Serial(self.port, self.baudrate, timeout=1)
            print(f"Ouvindo a porta serial {self.port} em {self.baudrate} bps...")
        except serial.SerialException as e:
            print(f"Erro ao abrir a porta serial: {e}")
            return

        while True:
            try:
                byte = ser.read(1)
                
                if not byte:
                    continue

                print(byte)
                
                match (byte[0]):
                    case 0xAA:  # Início do jogo
                        print("Início do jogo detectado.")
                        self.model.start = True
                    
                    case 0xAB:  # Dificuldade
                        print("Dificuldade detectada.")
                        payload_bytes = ser.read(1)
                        if len(payload_bytes) != 1:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        print(f"\n--- Pacote Completo Recebido ---")
                        print(f"Payload: {payload_bytes.hex()}")
                        game_difficulty = payload_bytes[0]
                        self.model.difficulty = bool(game_difficulty)
                        print(f"Dificuldade do jogo: {self.model.difficulty}")
                    case 0xAC:  # Mapa completo
                        print("Mapa completo recebido.")
                        full_map_bytes = ser.read(41)

                        print(len(full_map_bytes))

                        if len(full_map_bytes) != 41:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        
                        correct_map = full_map.decode_full_map(full_map_bytes)
                        self.model.map = correct_map
                        print(self.model.map)
                    
                    case 0xAD:  # Visibilidade
                        print("Visibilidade recebida.")
                        payload_bytes = ser.read(23)
                        if len(payload_bytes) != 23:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        print(f"\n--- Pacote Completo Recebido ---")
                        
                        status = game_status.decode_status(payload_bytes)
                        self.model.colors = status["colors"]
                        self.model.strikes = status["errors"]
                        self.model.position = status["position"]
                        self.model.selectedNumber = status["selected_number"]
                        
                        print(f"Status do jogo: {status}")
                    case 0xAE:  # Fim do jogo
                        print("Fim do jogo detectado.")
                        payload_bytes = ser.read(1)
                        if len(payload_bytes) != 1:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        print(f"\n--- Pacote Completo Recebido ---")
                        print(f"Payload: {payload_bytes}")
                        # transform to bits
                        print(f''.join(format(byte, '08b') for byte in payload_bytes))
                        valor = payload_bytes[0]
                        # Extrair o MSB (bit 7)
                        msb = bool((valor >> 7) & 0x1)

                        # Extrair os 7 bits restantes
                        decimal_7bits = valor & 0x7F  # 0b01111111

                        self.model.endgame = [decimal_7bits, msb]

                        print(f"MSB (booleano): {msb}")
                        print(f"7 bits restantes (decimal): {decimal_7bits}")
            
            except KeyboardInterrupt:
                print("Interrompido pelo usuário.")
                ser.close()
                break
            except Exception as e:
                print(f"Ocorreu um erro: {e}")
                ser.close()
                break
# Exemplo de como usar a classe
if __name__ == '__main__':
    model = Modelo()
    leitor = SerialReader(port='/dev/ttyUSB0', baudrate=115200, model=model)
    leitor.read_serial()