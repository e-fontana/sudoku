from screens.base_screen import BaseScreen
from screens.colors import Color
from screens.defeat_screen import DefeatScreen
from screens.difficulty_selection_screen import DifficultySelectionScreen
from screens.game_screen import GameScreen
from screens.menu_screen import MenuScreen
from screens.victory_screen import VictoryScreen
class Modelo:
    def __init__(self):
        self.start = False
        self.difficulty = False
        self.map = None
        self.colors = [[Color(2)] * 9 for _ in range(9)]
        self.position = [4,4]
        self.strikes = 0
        self.selectedNumber = 1
        self.endgame = False
        self.finishGame = False

    def setStart(self, value):
        self.start = value

    def setDifficulty(self, value):
        self.difficulty = value

    def setMap(self, value):
        self.map = value
        print(self.map)

    def setMap(self, value):
        self.map = []
        for i in range(9):
            self.map.append(value[9*i:9*i+8])
        self.map = value

    def setColors(self, value):
        self.colors = value

    def setPosition(self, value):
        self.position = value

    def setStrikes(self, value):
        self.strikes = value

    def setSelectedNumber(self, value):
        self.selectedNumer = value

    def setEndgame(self, value):
        self.endgame = value
        self.finishGame = value is not None