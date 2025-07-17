
class Modelo:
    def __init__(self):
        self.start = None
        self.difficulty = None
        self.map = None
        self.colors = []
        self.position = []
        self.strikes = 0
        self.selectedNumber = None
        self.endgame = None
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