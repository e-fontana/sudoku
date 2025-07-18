from screens import Modelo
from game import Game


modelo = Modelo()
game = Game(modelo=modelo, port='/dev/pts/7')  # Adjust the port as needed
game.run()
