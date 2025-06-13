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

    def __init__(self, output_file='saida.mif'):
        output_file = f"{os.getcwd()}/../maps/{output_file}"
        with open(output_file, 'w') as f:
            # f.write("DEPTH = 81;\n")
            # f.write("WIDTH = 4;\n")
            # f.write("ADDRESS_RADIX = DEC;\n")
            # f.write("DATA_RADIX = BIN;\n")
            # f.write("CONTENT BEGIN\n")

            index = 0
            for _ in range(1):
                sudoku = Sudoku()
                for i, row in enumerate(sudoku.solution):
                    for j, cell in enumerate(row):
                        MSB = '0' if sudoku.board[i][j] == 0 else '1'
                        bits = self.ENCODER[cell-1]
                        f.write(f"{MSB}{bits}\n")
                        index += 1
            
            # f.write("END;")
