import pygame
import sys
import random

# --- CONFIGURAÇÕES ---
WIDTH, HEIGHT = 800, 600
FPS = 60
BLOCK_SIZE = 50
PLAYER_SIZE = 40

# Cores
COLOR_BG = (20, 20, 30)
COLOR_PLAYER = (0, 200, 255)
COLOR_BLOCK = (150, 150, 150)
COLOR_CHECKPOINT = (255, 215, 0)
COLOR_MENU = (0, 0, 0, 150) # Fundo transparente para o menu

class Player:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, PLAYER_SIZE, PLAYER_SIZE)
        self.vel_y = 0
        self.vel_x = 0
        self.on_ground = False
        self.checkpoint_pos = (x, y)
        self.has_reached_first_cp = False
        self.total_emeralds = 0
        self.next_checkpoint = 80
        self.distance_traveled = 0

    def control(self):
        keys = pygame.key.get_pressed()
        self.vel_x = 0
        if keys[pygame.K_LEFT]: self.vel_x = -6
        if keys[pygame.K_RIGHT]: self.vel_x = 6
        if keys[pygame.K_SPACE] and self.on_ground:
            self.vel_y = -16
            self.on_ground = False

    def check_collisions(self, platforms):
        self.rect.x += self.vel_x
        for plat in platforms:
            if self.rect.colliderect(plat):
                if self.vel_x > 0: self.rect.right = plat.left
                if self.vel_x < 0: self.rect.left = plat.right

        self.rect.y += self.vel_y
        self.on_ground = False
        for plat in platforms:
            if self.rect.colliderect(plat):
                if self.vel_y > 0:
                    self.rect.bottom = plat.top
                    self.vel_y = 0
                    self.on_ground = True
                    self.distance_traveled = self.rect.x // 10
                    
                    if self.distance_traveled >= self.next_checkpoint:
                        self.checkpoint_pos = (self.rect.x, self.rect.y)
                        self.has_reached_first_cp = True
                        self.sortear_esmeralda()
                        self.next_checkpoint = 180 if self.next_checkpoint == 80 else self.next_checkpoint + 100

                elif self.vel_y < 0:
                    self.rect.top = plat.bottom
                    self.vel_y = 0

    def sortear_esmeralda(self):
        chance = random.randint(1, 100)
        if chance <= 5: self.total_emeralds += 8
        elif chance <= 25: self.total_emeralds += 4
        elif chance <= 80: self.total_emeralds += 1

def draw_death_menu(screen, font, player):
    # Desenha um fundo escurecido
    overlay = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
    overlay.fill((0, 0, 0, 180))
    screen.blit(overlay, (0,0))
    
    title = font.render("VOCÊ CAIU!", True, (255, 50, 50))
    screen.blit(title, (WIDTH//2 - 70, HEIGHT//2 - 100))
    
    if player.has_reached_first_cp:
        msg = f"Pressione 'R' para voltar ao Checkpoint ({player.distance_traveled}m)"
    else:
        msg = "Pressione 'R' para recomeçar do início"
    
    text = font.render(msg, True, (255, 255, 255))
    screen.blit(text, (WIDTH//2 - 200, HEIGHT//2))

def main():
    pygame.init()
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("Arial", 22, bold=True)
    
    player = Player(50, 450)
    platforms = [pygame.Rect(i*140, 500 - (i%3*50), BLOCK_SIZE, BLOCK_SIZE) for i in range(100)]
    
    game_over = False

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit(); sys.exit()
            
            if game_over and event.type == pygame.KEYDOWN:
                if event.key == pygame.K_r:
                    player.rect.x, player.rect.y = player.checkpoint_pos
                    player.vel_y = 0
                    game_over = False

        if not game_over:
            player.vel_y += 0.8
            player.control()
            player.check_collisions(platforms)
            if player.rect.top > HEIGHT: game_over = True

        # Câmera e Desenho
        camera_x = player.rect.x - WIDTH // 2
        screen.fill(COLOR_BG)
        
        for plat in platforms:
            pygame.draw.rect(screen, COLOR_BLOCK, (plat.x - camera_x, plat.y, plat.width, plat.height))
        
        pygame.draw.rect(screen, COLOR_PLAYER, (player.rect.x - camera_x, player.rect.y, PLAYER_SIZE, PLAYER_SIZE))

        # HUD
        esm_text = font.render(f"Esmeraldas: {player.total_emeralds}", True, (80, 255, 80))
        dist_text = font.render(f"Distância: {player.distance_traveled}m", True, (255, 255, 255))
        screen.blit(esm_text, (20, 20))
        screen.blit(dist_text, (20, 50))

        if game_over:
            draw_death_menu(screen, font, player)

        pygame.display.flip()
        clock.tick(FPS)

if __name__ == "__main__":
    main()
import pygame
import sys
import random

# --- CONFIGURAÇÕES ---
WIDTH, HEIGHT = 800, 600
FPS = 60
BLOCK_SIZE = 50
PLAYER_SIZE = 40

# Cores
COLOR_BG = (20, 20, 30)
COLOR_PLAYER = (0, 200, 255)
COLOR_BLOCK = (150, 150, 150)
COLOR_CHECKPOINT = (255, 215, 0)
COLOR_MENU = (0, 0, 0, 150) # Fundo transparente para o menu

class Player:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, PLAYER_SIZE, PLAYER_SIZE)
        self.vel_y = 0
        self.vel_x = 0
        self.on_ground = False
        self.checkpoint_pos = (x, y)
        self.has_reached_first_cp = False
        self.total_emeralds = 0
        self.next_checkpoint = 80
        self.distance_traveled = 0

    def control(self):
        keys = pygame.key.get_pressed()
        self.vel_x = 0
        if keys[pygame.K_LEFT]: self.vel_x = -6
        if keys[pygame.K_RIGHT]: self.vel_x = 6
        if keys[pygame.K_SPACE] and self.on_ground:
            self.vel_y = -16
            self.on_ground = False

    def check_collisions(self, platforms):
        self.rect.x += self.vel_x
        for plat in platforms:
            if self.rect.colliderect(plat):
                if self.vel_x > 0: self.rect.right = plat.left
                if self.vel_x < 0: self.rect.left = plat.right

        self.rect.y += self.vel_y
        self.on_ground = False
        for plat in platforms:
            if self.rect.colliderect(plat):
                if self.vel_y > 0:
                    self.rect.bottom = plat.top
                    self.vel_y = 0
                    self.on_ground = True
                    self.distance_traveled = self.rect.x // 10
                    
                    if self.distance_traveled >= self.next_checkpoint:
                        self.checkpoint_pos = (self.rect.x, self.rect.y)
                        self.has_reached_first_cp = True
                        self.sortear_esmeralda()
                        self.next_checkpoint = 180 if self.next_checkpoint == 80 else self.next_checkpoint + 100

                elif self.vel_y < 0:
                    self.rect.top = plat.bottom
                    self.vel_y = 0

    def sortear_esmeralda(self):
        chance = random.randint(1, 100)
        if chance <= 5: self.total_emeralds += 8
        elif chance <= 25: self.total_emeralds += 4
        elif chance <= 80: self.total_emeralds += 1

def draw_death_menu(screen, font, player):
    # Desenha um fundo escurecido
    overlay = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
    overlay.fill((0, 0, 0, 180))
    screen.blit(overlay, (0,0))
    
    title = font.render("VOCÊ CAIU!", True, (255, 50, 50))
    screen.blit(title, (WIDTH//2 - 70, HEIGHT//2 - 100))
    
    if player.has_reached_first_cp:
        msg = f"Pressione 'R' para voltar ao Checkpoint ({player.distance_traveled}m)"
    else:
        msg = "Pressione 'R' para recomeçar do início"
    
    text = font.render(msg, True, (255, 255, 255))
    screen.blit(text, (WIDTH//2 - 200, HEIGHT//2))

def main():
    pygame.init()
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("Arial", 22, bold=True)
    
    player = Player(50, 450)
    platforms = [pygame.Rect(i*140, 500 - (i%3*50), BLOCK_SIZE, BLOCK_SIZE) for i in range(100)]
    
    game_over = False

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit(); sys.exit()
            
            if game_over and event.type == pygame.KEYDOWN:
                if event.key == pygame.K_r:
                    player.rect.x, player.rect.y = player.checkpoint_pos
                    player.vel_y = 0
                    game_over = False

        if not game_over:
            player.vel_y += 0.8
            player.control()
            player.check_collisions(platforms)
            if player.rect.top > HEIGHT: game_over = True

        # Câmera e Desenho
        camera_x = player.rect.x - WIDTH // 2
        screen.fill(COLOR_BG)
        
        for plat in platforms:
            pygame.draw.rect(screen, COLOR_BLOCK, (plat.x - camera_x, plat.y, plat.width, plat.height))
        
        pygame.draw.rect(screen, COLOR_PLAYER, (player.rect.x - camera_x, player.rect.y, PLAYER_SIZE, PLAYER_SIZE))

        # HUD
        esm_text = font.render(f"Esmeraldas: {player.total_emeralds}", True, (80, 255, 80))
        dist_text = font.render(f"Distância: {player.distance_traveled}m", True, (255, 255, 255))
        screen.blit(esm_text, (20, 20))
        screen.blit(dist_text, (20, 50))

        if game_over:
            draw_death_menu(screen, font, player)

        pygame.display.flip()
        clock.tick(FPS)

if __name__ == "__main__":
    main()
