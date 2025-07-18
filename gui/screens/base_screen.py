class BaseScreen:
    def __init__(self, game):
        self.game = game

    def draw(self, screen):
        raise NotImplementedError("Subclasses should implement this method")
