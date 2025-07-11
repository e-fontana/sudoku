import tkinter as tk
import serial
import threading

porta_serial_PC = "/dev/ttyUSB11"  # Altere para sua porta
baudrate = 115200

class SudokuReceiver:
    def __init__(self, porta=porta_serial_PC, baudrate=baudrate):
        self.root = tk.Tk()
        self.root.title("Sudoku LABI-A")

        self.entries = [[None for _ in range(9)] for _ in range(9)] 
        self.cursor_pos = (0, 0)
        self.cores_disponiveis = ["white", "blue", "yellow", "red"]
        self.entrada_serial = serial.Serial(porta, baudrate)

        self.criar_interface()
        self.iniciar_thread_serial()

    def criar_interface(self):
        tabuleiro = tk.Frame(self.root, bg="black")
        tabuleiro.pack(padx=10, pady=10)

        for bloco_i in range(3):
            for bloco_j in range(3):
                frame_bloco = tk.Frame(tabuleiro, bg="black", bd=2, relief="solid")
                frame_bloco.grid(row=bloco_i, column=bloco_j, padx=2, pady=2)

                for i in range(3):
                    for j in range(3):
                        lin = bloco_i * 3 + i
                        col = bloco_j * 3 + j

                        entry = tk.Entry(
                            frame_bloco,
                            width=2,
                            font=("Arial", 20),
                            justify="center",
                            bg="#4E3131",  # cinza escuro
                            fg="white",
                            disabledbackground="#333333",
                            disabledforeground="white"
                        )
                        entry.grid(row=i, column=j, padx=1, pady=1)
                        entry.configure(state="readonly")
                        self.entries[lin][col] = entry

        self.status_label = tk.Label(self.root, text="Aguardando dados...")
        self.status_label.pack(pady=5)

    def iniciar_thread_serial(self):
        thread = threading.Thread(target=self.receber_serial, daemon=True)
        thread.start()

    def receber_serial(self):
        while True:
            try:
                if self.entrada_serial.in_waiting > 0:
                    linha = self.entrada_serial.readline().decode("utf-8").strip()

                    try:
                        parte_numeros, parte_cores, parte_cursor = linha.split("|")
                        numeros = [int(x) for x in parte_numeros.split(",")]
                        cores = [int(x) for x in parte_cores.split(",")]
                        linha_cursor, coluna_cursor = [int(x) for x in parte_cursor.split(",")]

                        if len(numeros) == 81 and len(cores) == 81:
                            self.cursor_pos = (linha_cursor, coluna_cursor)
                            self.preencher_tabuleiro(numeros, cores)
                    except Exception as e:
                        print("Erro ao processar dados:", e)

            except Exception as e:
                print("Erro na leitura serial:", e)

    def preencher_tabuleiro(self, numeros, cores):
        def atualizar_ui():
            r_cursor, c_cursor = self.cursor_pos

            for i in range(9):
                for j in range(9):
                    idx = i * 9 + j
                    val = numeros[idx]
                    cor_idx = cores[idx]
                    cor = self.cores_disponiveis[cor_idx]

                    entry = self.entries[i][j]

                    # Desbloqueia antes de editar
                    entry.configure(state="normal")
                    entry.delete(0, tk.END)

                    if val != 0:
                        entry.insert(0, str(val))
                        entry.configure(fg=cor)
                    else:
                        entry.insert(0, "")
                        entry.configure(fg="white")

                    # Fundo verde apenas para o cursor
                    if (i, j) == (r_cursor, c_cursor):
                        entry.configure(bg="green")
                    else:
                        entry.configure(bg="#333333")

                    # Mantém o campo normal para que a cor de fundo e texto apareçam corretamente
                    entry.configure(readonlybackground=entry["bg"])

            self.status_label.config(text=f"Cursor em ({r_cursor}, {c_cursor})")

        self.root.after(0, atualizar_ui)

    def atualizar_cursor_visual(self):
        for i in range(9):
            for j in range(9):
                self.entries[i][j].configure(bg="#333333")

        r, c = self.cursor_pos
        if 0 <= r < 9 and 0 <= c < 9:
            self.entries[r][c].configure(bg="green")

    def iniciar(self):
        self.root.mainloop()

if __name__ == "__main__":
    app = SudokuReceiver(porta=porta_serial_PC)
    app.iniciar()
