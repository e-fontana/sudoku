from game import Game
from data_treatment import Modelo

if __name__ == "__main__":
    modelo = Modelo()
    game = Game(modelo)
    game.run()