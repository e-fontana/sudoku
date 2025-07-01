import pygame
from .base_screen import BaseScreen

class GameScreen(BaseScreen):
    GRID_DIMENSION = 9
    CELL_SIZE = 50
    GRID_START_X = 175
    GRID_START_Y = 100

    # Cores
    CELL_BG_COLOR = (255, 255, 255, 30) # Branco semi-transparente para o fundo da célula
    THIN_BORDER_COLOR = (200, 200, 200, 80) # Cinza claro semi-transparente para bordas finas
    THICK_BORDER_COLOR = (255, 100, 200) # Rosa para bordas grossas (cor única)
    SELECTED_CELL_COLOR = (255, 255, 255, 80) # Branco mais claro e opaco para célula selecionada

    # Larguras de Borda
    THIN_BORDER_WIDTH = 1
    THICK_BORDER_WIDTH = 3
    CELL_BORDER_RADIUS = 0 # Células do Sudoku sem cantos arredondados (para manter o grid quadrado)

    # Cores de Neon (usadas no placeholder do timer e possivelmente nos números)
    NEON_BLUE = (0, 255, 255) # Ciano vibrante
    PURE_WHITE = (255, 255, 255) # Branco puro (para texto do timer e números)
    
    # Constantes para o Placeholder do Timer
    TIMER_RECT_WIDTH = 150
    TIMER_RECT_HEIGHT = 40
    TIMER_RECT_Y = 20 # Posição Y no topo central

    # Cores para o Placeholder do Timer
    TIMER_BG_COLOR = (50, 50, 50, 100) # Cinza escuro semi-transparente para o fundo do timer

    def __init__(self, game):
        super().__init__(game)
        self.font_timer = self.game.get_font(24) 
        self.font_numbers = self.game.get_font(36)

        # Posição inicial do cursor
        self.current_row = 4
        self.current_col = 4
        
        self.sudoku_board = [
            [5, 3, 0, 0, 7, 0, 0, 0, 0],
            [6, 0, 0, 1, 9, 5, 0, 0, 0],
            [0, 9, 8, 0, 0, 0, 0, 6, 0],
            [8, 0, 0, 0, 6, 0, 0, 0, 3],
            [4, 0, 0, 8, 0, 3, 0, 0, 1],
            [7, 0, 0, 0, 2, 0, 0, 0, 6],
            [0, 6, 0, 0, 0, 0, 2, 8, 0],
            [0, 0, 0, 4, 1, 9, 0, 0, 5],
            [0, 0, 0, 0, 8, 0, 0, 7, 9]
        ]
        
        self.start_ticks = pygame.time.get_ticks()

    def handle_event(self, event):
        if event.type == pygame.KEYDOWN:
            # Transição para telas de vitória/derrota (para teste)
            if event.key == pygame.K_v:
                self.game.set_state(self.game.STATE_VICTORY)
            elif event.key == pygame.K_d:
                self.game.set_state(self.game.STATE_DEFEAT)
            # Movimento do cursor
            elif event.key == pygame.K_UP:
                self.current_row = max(0, self.current_row - 1)
            elif event.key == pygame.K_DOWN:
                self.current_row = min(self.GRID_DIMENSION - 1, self.current_row + 1)
            elif event.key == pygame.K_LEFT:
                self.current_col = max(0, self.current_col - 1)
            elif event.key == pygame.K_RIGHT:
                self.current_col = min(self.GRID_DIMENSION - 1, self.current_col + 1)

    def update(self, _):
        self.game.elapsed_time = (pygame.time.get_ticks() - self.start_ticks) // 1000

    def draw(self, screen):
        screen.fill((0, 0, 0))

        # --- Desenho do Placeholder do Cronômetro ---
        timer_rect_x = self.game.WIDTH // 2 - self.TIMER_RECT_WIDTH // 2
        timer_rect = pygame.Rect(timer_rect_x, self.TIMER_RECT_Y, self.TIMER_RECT_WIDTH, self.TIMER_RECT_HEIGHT)
        
        # Fundo opaco do timer
        timer_surface = pygame.Surface(timer_rect.size, pygame.SRCALPHA)
        timer_surface.fill(self.TIMER_BG_COLOR) # Cor definida na GameScreen
        screen.blit(timer_surface, timer_rect.topleft)
        
        # Borda do timer
        pygame.draw.rect(screen, self.NEON_BLUE, timer_rect, 2, border_radius=5)

        # --- Desenho do Texto do Cronômetro (MM:SS) ---
        minutes = self.game.elapsed_time // 60
        seconds = self.game.elapsed_time % 60
        timer_text = f"{minutes:02d}:{seconds:02d}"

        timer_surface_text = self.font_timer.render(timer_text, True, self.PURE_WHITE) # Texto em branco puro
        timer_text_rect = timer_surface_text.get_rect(center=timer_rect.center)
        screen.blit(timer_surface_text, timer_text_rect)

        # --- DESENHO DO GRID DO SUDOKU ---
        for row in range(self.GRID_DIMENSION):
            for col in range(self.GRID_DIMENSION):
                x = self.GRID_START_X + col * self.CELL_SIZE
                y = self.GRID_START_Y + row * self.CELL_SIZE
                cell_rect = pygame.Rect(x, y, self.CELL_SIZE, self.CELL_SIZE)

                # Escolhe a cor de fundo da célula (normal ou selecionada)
                cell_fill_color = self.CELL_BG_COLOR # Cor padrão
                if row == self.current_row and col == self.current_col:
                    cell_fill_color = self.SELECTED_CELL_COLOR # Cor para a célula selecionada

                # Desenha o fundo opaco da célula com cantos arredondados (se CELL_BORDER_RADIUS > 0)
                cell_surface = pygame.Surface(cell_rect.size, pygame.SRCALPHA)
                pygame.draw.rect(cell_surface, cell_fill_color, (0, 0, cell_rect.width, cell_rect.height), border_radius=self.CELL_BORDER_RADIUS)
                screen.blit(cell_surface, cell_rect.topleft)

                # Desenha a borda fina da célula
                pygame.draw.rect(screen, self.THIN_BORDER_COLOR, cell_rect, self.THIN_BORDER_WIDTH, border_radius=self.CELL_BORDER_RADIUS)

                # Desenha as bordas grossas dos blocos 3x3 (apenas rosa)
                if col % 3 == 0 and col != 0: # Borda vertical esquerda do bloco
                    pygame.draw.line(screen, self.THICK_BORDER_COLOR, # Rosa
                                     (x, self.GRID_START_Y),
                                     (x, self.GRID_START_Y + self.GRID_DIMENSION * self.CELL_SIZE),
                                     self.THICK_BORDER_WIDTH)
                
                if row % 3 == 0 and row != 0: # Borda horizontal superior do bloco
                    pygame.draw.line(screen, self.THICK_BORDER_COLOR, # Rosa
                                     (self.GRID_START_X, y),
                                     (self.GRID_START_X + self.GRID_DIMENSION * self.CELL_SIZE, y),
                                     self.THICK_BORDER_WIDTH)

        # Desenha a borda externa do grid (rosa)
        grid_width = self.GRID_DIMENSION * self.CELL_SIZE
        grid_height = self.GRID_DIMENSION * self.CELL_SIZE
        outer_grid_rect = pygame.Rect(self.GRID_START_X, self.GRID_START_Y, grid_width, grid_height)
        pygame.draw.rect(screen, self.THICK_BORDER_COLOR, outer_grid_rect, self.THICK_BORDER_WIDTH + 1, border_radius=self.CELL_BORDER_RADIUS)

        # --- Desenho dos Números do Sudoku (exemplo) ---
        for r in range(self.GRID_DIMENSION):
            for c in range(self.GRID_DIMENSION):
                num = self.sudoku_board[r][c] # Pega o número do seu tabuleiro
                if num != 0: # Se a célula não estiver vazia
                    num_surface = self.font_numbers.render(str(num), True, self.PURE_WHITE) # Texto em branco puro
                    num_rect = num_surface.get_rect(center=(self.GRID_START_X + c * self.CELL_SIZE + self.CELL_SIZE // 2,
                                                             self.GRID_START_Y + r * self.CELL_SIZE + self.CELL_SIZE // 2))
                    screen.blit(num_surface, num_rect)