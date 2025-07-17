from screens import Modelo
from game import Game


modelo = Modelo()
# serial_reader = SerialReader('/dev/pts/12', 9600, modelo)
# serial_reader.read_serial()
game = Game(modelo=modelo)
game.run()

# from game import Game
# import time
# from screens import Modelo
# from screens.colors import Color

# if __name__ == "__main__":
#     modelo = Modelo()
#     game = Game(modelo)
#     game.run()
#     time.sleep(10)
#     modelo.setStart(True)

#     time.sleep(2)
#     modelo.setDifficulty(False)
#     time.sleep(2)
#     modelo.setDifficulty(True)
#     time.sleep(5)

#     modelo.map = [[4, 7, 8, 1, 6, 5, 2, 9, 3],
#                   [3, 2, 9, 4, 8, 7, 6, 5, 1],
#                   [6, 1, 5, 2, 3, 9, 4, 7, 8],
#                   [9, 3, 2, 5, 1, 6, 7, 8, 4],
#                   [8, 4, 1, 3, 7, 2, 5, 6, 9],
#                   [7, 5, 6, 9, 4, 8, 1, 3, 2],
#                   [2, 8, 7, 6, 9, 1, 3, 4, 5],
#                   [1, 9, 4, 7, 5, 3, 8, 2, 6],
#                   [5, 6, 3, 8, 2, 4, 9, 1, 7]]
#     modelo.colors = [[Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.TRANSPARENTE, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.TRANSPARENTE],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
#                      [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO]]
    
#     modelo.position = [4, 4]
#     modelo.strikes = 0
#     modelo.selectedNumber = 5
    