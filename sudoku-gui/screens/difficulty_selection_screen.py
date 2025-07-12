import pygame
from screens.base_screen import BaseScreen

class DifficultySelectionScreen(BaseScreen):
    BACKGROUND_IMAGE_PATH = "assets/images/difficulty_selection_bg.png"

    def __init__(self, game):
        super().__init__(game)
        self.font_difficulty = game.get_font(32)
        self.options = ["easy", "hard"]
        self.selected_index = 0

        self.background_image = pygame.image.load(self.BACKGROUND_IMAGE_PATH)
        self.background_image = pygame.transform.scale(self.background_image, (game.WIDTH, game.HEIGHT))
    
    def handle_event(self, event):
        if self.game.modelo.difficulty :
            self.selected_index = 1
        else:
            self.selected_index = 0
        if self.game.modelo.receivedAnswerKey():
                chosen_difficulty = self.options[self.selected_index]
                print(f"Dificuldade escolhida: {chosen_difficulty}")
                self.game.set_state(self.game.STATE_GAME)
                print("Iniciando jogo...")
    
    def draw(self, screen):
        screen.blit(self.background_image, (0, 0))

        RECT_WIDTH = 300
        RECT_HEIGHT = 60

        gap = 20
        total_height_options = len(self.options) * (RECT_HEIGHT + gap)
        start_y = (self.game.HEIGHT - total_height_options) // 2

        for i, option_text in enumerate(self.options):
            x_rect = (self.game.WIDTH - RECT_WIDTH) // 2
            y_rect = start_y + i * (RECT_HEIGHT + gap)

            background_rect = pygame.Rect(x_rect, y_rect, RECT_WIDTH, RECT_HEIGHT)

            if i == self.selected_index:
                s = pygame.Surface(background_rect.size, pygame.SRCALPHA)
                pygame.draw.rect(s, self.game.COLORS['OPAQUE_WHITE'], s.get_rect(), border_radius=10)
                screen.blit(s, background_rect.topleft)

                border_color = self.game.COLORS['BLUE'] if option_text == "easy" else self.game.COLORS['PINK']
                pygame.draw.rect(screen, border_color, background_rect, 2, border_radius=10)

            text_surface = self.font_difficulty.render(option_text, True, self.game.COLORS['WHITE'])
            text_rect = text_surface.get_rect(center=(background_rect.center))
            screen.blit(text_surface, text_rect)
