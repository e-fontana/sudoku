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

    visibilities = []
    bits = []
    sudokus = []

    def write_map(self, clues):
        sudoku = Sudoku(clues=clues)
        self.sudokus.append(sudoku)
        for i, row in enumerate(sudoku.solution):
            for j, cell in enumerate(row):
                self.visibilities.append('00' if sudoku.board[i][j] == 0 else '11')
                self.bits.append(self.ENCODER[cell-1])

    def define(self, void_cells_easy=2, void_cells_hard=10):
        for _ in range(15):
            self.write_map(81-void_cells_easy)
        for _ in range(15):
            self.write_map(81-void_cells_hard)
        self.visibilities.reverse()
        self.bits.reverse()

    def __init__(self, void_cells_easy=2, void_cells_hard=10, output_file='output.v'):
        self.define(void_cells_easy, void_cells_hard)

        output_file = f"{os.getcwd()}/../modules/game/{output_file}"
        with open(f"{os.getcwd()}/maps-viewer.txt", 'w') as f:
            for sudoku in self.sudokus:
                f.write(f"{sudoku.print_sudoku()}\n")

        with open(output_file, 'w') as f:
            f.write("module define_maps(\n")
            f.write(f"\toutput [{81*2*30 - 1}:0] visibilities,\n")
            f.write(f"\toutput [{81*4*30 - 1}:0] maps\n")
            f.write(");\n")
            f.write(f"\tassign visibilities = {81*2*30}'b{"".join(self.visibilities)};\n")
            f.write(f"\tassign maps = {81*4*30}'b{"".join(self.bits)};\n")
            f.write("endmodule\n")
