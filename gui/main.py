from screens import Modelo
from game import Game


modelo = Modelo()
game = Game(modelo=modelo)  # Adjust the port as needed
game.run()
