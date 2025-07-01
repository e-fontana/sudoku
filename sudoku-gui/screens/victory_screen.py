import pygame
from screens.base_screen import BaseScreen

class VictoryScreen(BaseScreen):
    BACKGROUND_IMAGE_PATH = "assets/images/victory_bg.png"

    def __init__(self, game):
        super().__init__(game)
        
        self.background_image = pygame.image.load(self.BACKGROUND_IMAGE_PATH)
        self.background_image = pygame.transform.scale(self.background_image, (game.WIDTH, game.HEIGHT))
    
    def handle_event(self, event):
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                self.game.set_state(self.game.STATE_MENU)
                print("Voltando para Menu Principal")
    
    def draw(self, screen):
        screen.blit(self.background_image, (0, 0))
