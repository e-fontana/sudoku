import os
from sudoku import Sudoku

class Formatter:
    ENCODER = [
        '0001',
        '0010',
        '0011',
        '0100',
        '0101',
        '0110',
        '0111',
        '1000',
        '1001',
        '0000',
    ]

    visibilities_easy = []
    visibilities_hard = []
    bits_easy = []
    bits_hard = []
    sudokus = []

    def generate_sudoku_easy(self, void_cells=20):
        sudoku = Sudoku(clues=81-void_cells)
        self.sudokus.append(sudoku)
        for i, row in enumerate(sudoku.solution):
            for j, cell in enumerate(row):
                self.visibilities_easy.append('00' if sudoku.board[i][j] == 0 else '11')
                self.bits_easy.append(self.ENCODER[cell-1])
    
    def generate_sudoku_hard(self, void_cells=40):
        sudoku = Sudoku(clues=81-void_cells)
        self.sudokus.append(sudoku)
        for i, row in enumerate(sudoku.solution):
            for j, cell in enumerate(row):
                self.visibilities_hard.append('00' if sudoku.board[i][j] == 0 else '11')
                self.bits_hard.append(self.ENCODER[cell-1])

    def define(self, void_cells_easy=2, void_cells_hard=4):
        for _ in range(8):
            self.generate_sudoku_easy()
        for _ in range(8):
            self.generate_sudoku_hard()
        self.visibilities_easy.reverse()
        self.visibilities_hard.reverse()
        self.bits_easy.reverse()
        self.bits_hard.reverse()

    def __init__(self, void_cells_easy=2, void_cells_hard=4, output_file='output.v'):
        self.define(void_cells_easy, void_cells_hard)

        output_file = f"{os.getcwd()}/../modules/game/{output_file}"
        with open(f"{os.getcwd()}/maps-viewer.txt", 'w') as f:
            for sudoku in self.sudokus:
                f.write(f"{sudoku.print_sudoku()}\n")

        with open(output_file, 'w') as f:
            f.write("module define_maps(\n")
            f.write(f"\toutput [{81*2*8 - 1}:0] visibilities_easy,\n")
            f.write(f"\toutput [{81*2*8 - 1}:0] visibilities_hard,\n")
            f.write(f"\toutput [{81*4*8 - 1}:0] maps_easy,\n")
            f.write(f"\toutput [{81*4*8 - 1}:0] maps_hard\n")
            f.write(");\n")
            f.write(f"\tassign visibilities_easy = {81*2*8}'b{"".join(self.visibilities_easy)};\n")
            f.write(f"\tassign visibilities_hard = {81*2*8}'b{"".join(self.visibilities_hard)};\n")
            f.write(f"\tassign maps_easy = {81*4*8}'b{"".join(self.bits_easy)};\n")
            f.write(f"\tassign maps_hard = {81*4*8}'b{"".join(self.bits_hard)};\n")
            f.write("endmodule\n")
