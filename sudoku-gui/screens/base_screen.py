class BaseScreen:
    def __init__(self, game):
        self.game = game

    def handle_event(self, event):
        raise NotImplementedError("Subclasses should implement this method")

    def draw(self, screen):
        raise NotImplementedError("Subclasses should implement this method")
