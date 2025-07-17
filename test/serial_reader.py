import serial
from data_treatment import game_status, full_map

EVENT_LIST = {
    0xAA: "start",
    0xAB: "dificulty",
    0xAC: "full_map",
    0xAD: "visibility",
    0xAE: "end_game",
}

class SerialReader:
    def __init__(self, game, port = '/dev/ttyUSB0', baudrate = 115200):
        self.port = port
        self.baudrate = baudrate
        self.game = game
        self.current_state = None

    def read_serial(self):
        """
        Lê a porta serial, sincroniza com o cabeçalho 'AD' (0x4144)
        e desempacota o payload de 192 bits.
        """
        try:
            ser = serial.Serial(self.port, self.baudrate)
            print(f"Ouvindo a porta serial {self.port} em {self.baudrate} bps...")
        except serial.SerialException as e:
            print(f"Erro ao abrir a porta serial: {e}")
            return

        while True:
            try:
                byte = ser.read(1)
                
                if not byte:
                    continue

                match (byte[0]):
                    case 0xAA:  # Início do jogo
                        self.game.handleStateChange("DIFICULTY")
                        print("Início do jogo detectado.")
                    
                    case 0xAB:  # Dificuldade
                        self.game.handleStateChange("DIFICULTY")
                        payload_bytes = ser.read(1)
                        if len(payload_bytes) != 1:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        print(f"\n--- Pacote Completo Recebido ---")
                        
                        print(f"Payload: {payload_bytes.hex()}")
                        game_difficulty = payload_bytes[0]
                        self.game.modelo.difficulty = bool(game_difficulty)
                        
                        print(f"Dificuldade do jogo: {bool(game_difficulty)}")
                    case 0xAC:  # Mapa completo
                        full_map_bytes = ser.read(41)
                        if len(full_map_bytes) != 41:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue

                        correct_map = full_map.decode_full_map(full_map_bytes)
                        self.game.modelo.map = correct_map
                        print("MAP SERIAL", self.game.modelo.map)

                    case 0xAD:  # Visibilidade
                        payload_bytes = ser.read(23)
                        if len(payload_bytes) != 23:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        
                        status = game_status.decode_status(payload_bytes)
                        self.game.modelo.colors = status["colors"]
                        self.game.modelo.strikes = status["errors"]
                        self.game.modelo.position = status["position"]
                        self.game.modelo.selectedNumber = status["selected_number"]
                        self.game.handleStateChange("GAME")

                    case 0xAE:  # Fim do jogo
                        payload_bytes = ser.read(1)
                        if len(payload_bytes) != 1:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        valor = payload_bytes[0]
                        # Extrair o MSB (bit 7)
                        msb = bool((valor >> 7) & 0x1)

                        # Extrair os 7 bits restantes
                        decimal_7bits = valor & 0x7F  # 0b01111111
                        self.game.handleStateChange("VICTORY" if msb else "DEFEAT")
                        self.game.modelo.endgame = [decimal_7bits, msb]
            
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
    leitor = SerialReader(port='/dev/pts/12', baudrate=9600, model=model)
    leitor.read_serial()