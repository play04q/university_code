import pygame
import time
import random

pygame.init()

# 颜色定义
white = (255, 255, 255)
black = (0, 0, 0)
red = (213, 50, 80)
green = (0, 255, 0)
blue = (50, 153, 213)

# 窗口大小
width = 600
height = 400

# 初始化窗口
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("贪吃蛇")

# 游戏主循环
def gameLoop():
    game_over = False
    game_close = False

    # 蛇头位置、大小和速度
    x1 = width / 2
    y1 = height / 2
    snake_size = 10
    snake_speed = 15

    # 蛇的初始长度
    x1_change = 0
    y1_change = 0

    # 食物的位置（随机）
    foodx = round(random.randrange(0, width - snake_size) / 10.0) * 10.0
    foody = round(random.randrange(0, height - snake_size) / 10.0) * 10.0

    # 主循环
    while not game_over:

        # 结束页面循环
        while game_close == True:
            screen.fill(black)
            font_style = pygame.font.SysFont(None, 50)
            message = font_style.render("你输了！", blue)
            screen.blit(message, [width / 6, height / 3])

            # 异步监听事件（包括退出游戏和重新开始）
            pygame.display.update()
            for event in pygame.event.get():
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_q:
                        game_over = True
                        game_close = False
                    if event.key == pygame.K_c:
                        gameLoop()

        # 异步监听事件
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                game_over = True
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    x1_change = -snake_size
                    y1_change = 0
                elif event.key == pygame.K_RIGHT:
                    x1_change = snake_size
                    y1_change = 0
                elif event.key == pygame.K_UP:
                    y1_change = -snake_size
                    x1_change = 0
                elif event.key == pygame.K_DOWN:
                    y1_change = snake_size
                    x1_change = 0

        # 如果蛇突出窗口左右边缘则结束游戏               
        if x1 >= width or x1 < 0 or y1 >= height or y1 < 0:
            game_close = True

        # 改变蛇的位置（实现移动）
        x1 += x1_change
        y1 += y1_change

        # 填充颜色
        screen.fill(black)

        # 画出食物
        pygame.draw.rect(screen, green, [foodx, foody, snake_size, snake_size])

        # 画出蛇身
        pygame.draw.rect(screen, white, [x1, y1, snake_size, snake_size])

        # 刷新屏幕
        pygame.display.update()

        # 如果蛇头和食物坐标重合了，就增加蛇身长度（食物随机生成新位置）
        if x1 == foodx and y1 == foody:
            foodx = round(random.randrange(0, width - snake_size) / 10.0) * 10.0
            foody = round(random.randrange(0, height - snake_size) / 10.0) * 10.0
            snake_speed += 5

        # 刷新屏幕
        pygame.display.update()

        # 将改变的蛇头绘制到蛇身上，形成一条蛇
        if game_close == True:
            message("你输了！", red)
            time.sleep(2)

        # 控制蛇的移动速度
        clock = pygame.time.Clock()
        clock.tick(snake_speed)

    # 退出游戏
    pygame.quit()
    quit()

# 开始游戏循环
gameLoop()