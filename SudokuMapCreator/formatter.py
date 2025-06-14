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
        output_file = f"{os.getcwd()}/../{output_file}"
        with open(output_file, 'w') as f:
            f.write("module map(\n")
            f.write(f"\toutput reg [404:0] ")
            for map in range(50):
                f.write(f"map{map}\n" if map == 19 else f"map{map}, ")
            f.write(");\n")

            index = 0
            for map in range(50):
                sudoku = Sudoku()
                f.write(f"\t assign map{map} = 405'b")
                for i, row in enumerate(sudoku.solution):
                    for j, cell in enumerate(row):
                        MSB = '0' if sudoku.board[i][j] == 0 else '1'
                        bits = self.ENCODER[cell-1]
                        f.write(f"{MSB}{bits}")
                        index += 1
                f.write(";\n")
            
            f.write("endmodule\n")
            # f.write("END;")
