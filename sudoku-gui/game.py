import pygame
from screens import MenuScreen, DifficultySelectionScreen, GameScreen, VictoryScreen, DefeatScreen

class Game:
    WIDTH = 800
    HEIGHT = 700
    TITLE = "SUDOKU"

    # ESTADOS
    STATE_MENU = 0
    STATE_DIFFICULTY_SELECTION = 1
    STATE_GAME = 2
    STATE_VICTORY = 3
    STATE_DEFEAT = 4

    # CORES
    BACKGROUND_COLOR = (0, 0, 0)
    COLORS = {
        'WHITE': (255, 255, 255),
        'OPAQUE_WHITE': (255, 255, 255, 80),
        'BLUE': (0, 255, 255),
        'PINK': (255, 100, 200)
    }

    # FONTES
    font_path = "assets/fonts/PressStart2P-Regular.ttf"


    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((self.WIDTH, self.HEIGHT))
        pygame.display.set_caption(self.TITLE)

        self.current_state = self.STATE_MENU
        self.screens = {
            self.STATE_MENU: MenuScreen(self),
            self.STATE_DIFFICULTY_SELECTION: DifficultySelectionScreen(self),
            self.STATE_GAME: GameScreen(self),
            self.STATE_VICTORY: VictoryScreen(self),
            self.STATE_DEFEAT: DefeatScreen(self)
        }
        self.running = True
        self.clock = pygame.time.Clock()
    
    def set_state(self, new_state):
        self.current_state = new_state
    
    def get_font(self, size):
        return pygame.font.Font(self.font_path, size)
    
    def run(self):
        while self.running:
            dt = self.clock.tick(60) / 1000.0

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.running = False
                self.screens[self.current_state].handle_event(event)
            
            if hasattr(self.screens[self.current_state], 'update'):
                self.screens[self.current_state].update(dt)
                
            self.screen.fill(self.BACKGROUND_COLOR)
            self.screens[self.current_state].draw(self.screen)
            pygame.display.flip()

        pygame.quit()
        print("Jogo finalizado.")