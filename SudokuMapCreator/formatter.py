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

    def define(self):
        for _ in range(15):
            sudoku = Sudoku()
            for i, row in enumerate(sudoku.solution):
                for j, cell in enumerate(row):
                    self.visibilities.append('0' if sudoku.board[i][j] == 0 else '1')
                    self.bits.append(self.ENCODER[cell-1])

    def __init__(self, output_file='output.v'):
        self.define()

        output_file = f"{os.getcwd()}/../{output_file}"
        with open(output_file, 'w') as f:
            f.write("module define_maps(\n")
            f.write(f"\toutput [{81*15 - 1}:0] visibilities,\n")
            f.write(f"\toutput [{81*4*15 - 1}:0] maps\n")
            f.write(");\n")
            f.write(f"\tassign visibilites = {81*15}'b{"".join(self.visibilities)};\n")
            f.write(f"\tassign maps = {81*4*15}'b{"".join(self.bits)};\n")
            f.write("endmodule\n")
