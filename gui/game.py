import os
import pygame
import threading
from serial_reader import SerialReader
from screens import MenuScreen, DifficultySelectionScreen, GameScreen, VictoryScreen, DefeatScreen, Modelo


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
    font_path = f"{os.getcwd()}/assets/fonts/PressStart2P-Regular.ttf"


    def __init__(self, modelo: Modelo, port='/dev/ttyUSB0'):
        pygame.init()
        self.modelo = modelo
        self.serial_reader = SerialReader(self, port, 115200)
        REFRESH = pygame.USEREVENT + 1
        pygame.time.set_timer(REFRESH, 30)

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
        self.t = threading.Thread(target=self.serial_reader.read_serial)
        self.t.start()
        self.running = True
        self.clock = pygame.time.Clock()
    
    def set_state(self, new_state):
        pass

    def handleStateChange(self, new_state):
        match (new_state):
            case "START":
                self.current_state = self.STATE_MENU
            case "DIFFICULTY":
                self.current_state = self.STATE_DIFFICULTY_SELECTION
            case "BOARD":
                self.current_state = self.STATE_GAME
            case "GAME":
                self.current_state = self.STATE_GAME
            case "VICTORY":
                self.current_state = self.STATE_VICTORY
            case "DEFEAT":
                self.current_state = self.STATE_DEFEAT
    
    def get_font(self, size):
        return pygame.font.Font(self.font_path, size)
    
    def run(self):
        # i = 0
        while self.running:
            dt = self.clock.tick(60) / 1000.0

            # if(i == 100):
            #     self.modelo.setStart(True)
            # elif(i == 150):
            #     self.modelo.setDifficulty(True)
            # elif(i == 200):
            #     self.modelo.setDifficulty(False)
            # elif(i == 250):
            #     self.modelo.map =  [[4, 7, 8, 1, 6, 5, 2, 9, 3],
            #                     [3, 2, 9, 4, 8, 7, 6, 5, 1],
            #                     [6, 1, 5, 2, 3, 9, 4, 7, 8],
            #                     [9, 3, 2, 5, 1, 6, 7, 8, 4],
            #                     [8, 4, 1, 3, 7, 2, 5, 6, 9],
            #                     [7, 5, 6, 9, 4, 8, 1, 3, 2],
            #                     [2, 8, 7, 6, 9, 1, 3, 4, 5],
            #                     [1, 9, 4, 7, 5, 3, 8, 2, 6],
            #                     [5, 6, 3, 8, 2, 4, 9, 1, 7]]
            #     self.modelo.colors = [[Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.TRANSPARENTE, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.TRANSPARENTE],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO],
            #                           [Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO, Color.BRANCO]]
            #     self.modelo.position = [4, 4]
            #     self.modelo.strikes = 0
            #     self.modelo.selectedNumber = 5
            # elif (i == 300):
            #     self.modelo.position = [5, 4]
            # elif (i == 350):
            #     self.modelo.colors[5][4] = Color.AMARELO
            # elif (i == 400):
            #     self.modelo.selectedNumber = 4
            # elif (i == 450):
            #     self.modelo.colors[5][4] = Color.BRANCO
            # elif (i == 500):
            #     self.modelo.position = [5, 5]
            # elif (i == 525):
            #     self.modelo.position = [5, 6]
            # elif (i == 550):
            #     self.modelo.position = [5, 7]
            # elif (i == 575):
            #     self.modelo.position = [5, 8]
            # elif (i == 600):
            #     self.modelo.position = [6, 8]
            # elif (i == 625):
            #     self.modelo.colors[6][8] = Color.AMARELO
            # elif (i == 650):
            #     self.modelo.colors[6][8] = Color.VERMELHO
            # elif (i == 675):
            #     self.modelo.selectedNumber = 5
            # elif (i == 700):
            #     self.modelo.colors[6][8] = Color.BRANCO
            # elif (i == 800):
            #     self.modelo.finishGame = True
            #     self.modelo.endgame = [69420, False]
            
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.running = False
                self.screens[self.current_state].handle_event(event)
            
            if hasattr(self.screens[self.current_state], 'update'):
                self.screens[self.current_state].update(dt)
                
            self.screen.fill(self.BACKGROUND_COLOR)
            self.screens[self.current_state].draw(self.screen)
            pygame.display.flip()
            # i += 1

        pygame.quit()
        self.t.join()
        print("Jogo finalizado.")
