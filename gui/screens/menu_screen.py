import os
import math
import pygame
from screens.base_screen import BaseScreen

class MenuScreen(BaseScreen):
    START_BUTTON = "START"
    INSTRUCTION = f"press {START_BUTTON} to begin"

    BACKGROUND_IMAGE_PATH = f"{os.getcwd()}/assets/images/main_menu_bg.png"

    PULSE_COLOR_SPEED = 3
    PULSE_MIN_BRIGHTNESS = 150
    PULSE_MAX_BRIGHTNESS = 255

    PULSE_SCALE_SPEED = 0.5
    PULSE_MIN_SCALE = 0.95
    PULSE_MAX_SCALE = 1.05

    def __init__(self, game):
        super().__init__(game)
        self.font_title = game.get_font(74)
        self.font_instruction = game.get_font(18)   

        self.text_title = self.font_title.render(self.game.TITLE, True, game.COLORS['BLUE'])
        self.rect_title = self.text_title.get_rect(center=(game.WIDTH // 2, game.HEIGHT // 2 - 40))

        self.current_pulse_color_value = self.PULSE_MIN_BRIGHTNESS
        self.current_pulse_scale_value = self.PULSE_MIN_SCALE
        self.pulse_timer = 0.0

        self.background_image = pygame.image.load(self.BACKGROUND_IMAGE_PATH)
        self.background_image = pygame.transform.scale(self.background_image, (game.WIDTH, game.HEIGHT))

    def handle_event(self, event):
        if event and self.game.modelo.start:
            self.game.set_state(self.game.STATE_DIFFICULTY_SELECTION)
            print("Mudando para Seleção de Dificuldade")
    
    def update(self, dt):
        self.pulse_timer += dt
        
        color_amplitude = (self.PULSE_MAX_BRIGHTNESS - self.PULSE_MIN_BRIGHTNESS) / 2
        color_offset = self.PULSE_MIN_BRIGHTNESS + color_amplitude
        self.current_pulse_color_value = color_offset + color_amplitude * math.sin(self.pulse_timer * self.PULSE_COLOR_SPEED)
        self.current_pulse_color_value = max(self.PULSE_MIN_BRIGHTNESS, min(self.current_pulse_color_value, self.PULSE_MAX_BRIGHTNESS))

        scale_amplitude = (self.PULSE_MAX_SCALE - self.PULSE_MIN_SCALE) / 2
        scale_offset = self.PULSE_MIN_SCALE + scale_amplitude
        self.current_pulse_scale_value = scale_offset + scale_amplitude * math.sin(self.pulse_timer * self.PULSE_SCALE_SPEED * 2 * math.pi)
        self.current_pulse_scale_value = max(self.PULSE_MIN_SCALE, min(self.current_pulse_scale_value, self.PULSE_MAX_SCALE))

    def draw(self, screen):
        screen.blit(self.background_image, (0, 0))
        screen.blit(self.text_title, self.rect_title)

        base_r, base_g, base_b = self.game.COLORS['PINK']
        pulsing_r = int(base_r * (self.current_pulse_color_value / 255))
        pulsing_g = int(base_g * (self.current_pulse_color_value / 255))
        pulsing_b = int(base_b * (self.current_pulse_color_value / 255))
        pulsing_color = (pulsing_r, pulsing_g, pulsing_b)

        original_text_instruction = self.font_instruction.render(self.INSTRUCTION, True, pulsing_color)

        scaled_width = int(original_text_instruction.get_width() * self.current_pulse_scale_value)
        scaled_height = int(original_text_instruction.get_height() * self.current_pulse_scale_value)

        scaled_width = max(scaled_width, 1)
        scaled_height = max(scaled_height, 1)

        scaled_text_instruction = pygame.transform.scale(original_text_instruction, (scaled_width, scaled_height))

        rect_instruction = scaled_text_instruction.get_rect(center=(self.game.WIDTH // 2, self.game.HEIGHT // 2 + 40))
        screen.blit(scaled_text_instruction, rect_instruction)
