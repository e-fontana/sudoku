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
    def __init__(self, port, baudrate, model=None): # model é opcional
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
                    case 0xAB:  # Dificuldade
                        print("Dificuldade detectada.")
                    case 0xAC:  # Mapa completo
                        print("Mapa completo recebido.")
                        full_map_bytes = ser.read(41)
                        
                        if len(full_map_bytes) != 41:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        
                        correct_map = full_map.decode_full_map(full_map_bytes)
                        print(correct_map)
                    
                    case 0xAD:  # Visibilidade
                        print("Visibilidade recebida.")
                        payload_bytes = ser.read(23)
                        if len(payload_bytes) != 23:
                            print("Pacote incompleto após cabeçalho. Descartando.")
                            continue
                        print(f"\n--- Pacote Completo Recebido ---")
                        status = game_status.decode_status(payload_bytes)
                        print(status)
                    case 0xAE:  # Fim do jogo
                        print("Fim do jogo detectado.")
            
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
    # Altere a porta 'COM3' para a porta correta no seu sistema ('/dev/ttyUSB0', etc.)
    leitor = SerialReader(port='/dev/ttyUSB0', baudrate=115200)
    leitor.read_serial()