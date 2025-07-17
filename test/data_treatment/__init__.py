class Modelo:
    def __init__(self):
        self.start = None
        self.difficulty = None
        self.map = None
        self.visibility = []
        self.position = []
        self.strikes = 0
        self.selectedNumber = None
        self.endgame = None
        self.finishGame = False

    def setStart(self, value):
        self.start = value

    def setDificulty(self, value):
        self.difficulty = value

    def setMap(self, value):
        self.map = value

    def setVisibility(self, vis_data, pos_data, strikes_data, selected_number):
        self.visibility = vis_data
        self.position = pos_data
        self.strikes = strikes_data
        self.selectedNumber = selected_number

    def setEndgame(self, value):
        self.endgame = value
        self.finishGame = value is not None