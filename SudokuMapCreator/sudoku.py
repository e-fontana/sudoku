import random
import copy

class Sudoku:
    def __init__(self):
        self.solution = [[0] * 9 for _ in range(9)]
        self.fill_board()
        if not self.is_solution_valid():
            print("Não foi possível encontrar solução válida")
            return
        self.board = copy.deepcopy(self.solution)
        self.remove_cells()
    
    def has_unique_solution(self):
        board_copy = copy.deepcopy(self.solution)
        return True if self.solve(board_copy) == 1 else False
    
    def solve(self, board, count=0):
        for row in range(9):
            for col in range(9):
                if board[row][col] == 0:
                    for num in range(1, 10):
                        if self.is_number_valid(row, col, num):
                            board[row][col] = num
                            if count > 1:
                                return count
                            board[row][col] = 0
                    return count
        return count + 1

    def is_solution_valid(self):
        for i in range(9):
            for j in range(9):
                if not self.is_number_valid(i, j, self.solution[i][j]):
                    return False
        return True
    
    def is_number_valid(self, row, col, num):
        # verifica se existe o mesmo número na coluna ou linha
        for i in range(9):
            if (i != col and self.solution[row][i] == num) or (i != row and self.solution[i][col] == num):
                return False
        # verifica se existe o mesmo número no bloco 3x3
        box_start_row, box_start_col = 3 * (row // 3), 3 * (col // 3)
        for i in range(3):
            if box_start_row + i == row:
                continue
            for j in range(3):
                if box_start_col + j == col:
                    continue
                if self.solution[box_start_row + i][box_start_col + j] == num:
                    return False
        # número em posição válida
        return True 
    
    def fill_board(self):
        nums = list(range(1, 10))
        for row in range(9):
            for col in range(9):
                if self.solution[row][col] == 0:
                    random.shuffle(nums)
                    for n in nums:
                        if self.is_number_valid(row, col, n):
                            self.solution[row][col] = n
                            if self.fill_board():
                                return True
                            self.solution[row][col] = 0
                    return False
        return True

    def remove_cells(self, clues=70):
        positions = [(i, j) for i in range(9) for j in range(9)]
        random.shuffle(positions)

        while len(positions) > 0 and sum(cell != 0 for row in self.board for cell in row) > clues:
            row, col = positions.pop()
            temp = self.board[row][col]
            self.board[row][col] = 0

            if not self.has_unique_solution():
                self.board[row][col] = temp
    
    def format_cell(self, cell):
        return str(cell) if cell != 0 else "·"
    
    def print_sudoku(self):
        print("╔═══════╦═══════╦═══════╗")
        for i in range(9):
            row = "║"
            for j in range(9):
                row += f" {self.format_cell(self.board[i][j])}"
                if (j + 1) % 3 == 0:
                    row += " ║"
            print(row)
            if (i + 1) % 3 == 0 and i != 8:
                print("╠═══════╬═══════╬═══════╣")
        print("╚═══════╩═══════╩═══════╝")
        

