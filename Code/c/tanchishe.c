#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <conio.h>
#include <windows.h>

#define MAX_X 30  // 地图最大X坐标
#define MAX_Y 20  // 地图最大Y坐标
#define MAX_LEN 80  // 蛇最长长度

int map[MAX_X][MAX_Y];  // 地图
int len;  // 蛇的长度
int fx, fy;  // 食物的位置
int dx, dy;  // 蛇的移动方向
int score;  // 得分

// 初始化游戏
void InitGame() {
    // 清空地图
    for (int i = 0; i < MAX_X; i++) {
        for (int j = 0; j < MAX_Y; j++) {
            map[i][j] = 0;
        }
    }
    // 设置蛇的初始位置和食物的位置
    int x = MAX_X / 2, y = MAX_Y / 2;
    map[x][y] = 1;
    map[x][y+1] = 2;
    map[x][y+2] = 3;
    fx = rand() % MAX_X;
    fy = rand() % MAX_Y;
    len = 3;
    dx = 0, dy = -1;
    score = 0;
}

// 显示地图和蛇
void Show() {
    system("cls");
    printf("\n");
    for (int i = 0; i < MAX_X; i++) {
        printf("|");
        for (int j = 0; j < MAX_Y; j++) {
            if (map[i][j] == 0) {
                printf(" ");
            } else if (map[i][j] <= len) {
                printf("*");
            } else {
                printf("#");
            }
        }
        printf("|");
        printf("\n");
    }
    printf("score: %d\n", score);
}

// 更新游戏
void Update() {
    // 计算新的头的位置
    int nx = (len+1) * dx + (map[0][0]-1) % (len+1);
    int ny = (len+1) * dy + (map[0][0]-1) / (len+1);
    // 处理边界
    if (nx < 0) {
        nx = MAX_X - 1;
    }
    if (nx >= MAX_X) {
        nx = 0;
    }
    if (ny < 0) {
        ny = MAX_Y - 1;
    }
    if (ny >= MAX_Y) {
        ny = 0;
    }
    // 判断是否吃到食物
    if (nx == fx && ny == fy) {
        len++;
        score += 10;
        map[fx][fy] = 0;
        fx = rand() % MAX_X;
        fy = rand() % MAX_Y;
    }
    // 判断是否撞到自己
    if (map[nx][ny] > 0 && map[nx][ny] <= len) {
        printf("Game Over!\n");
        exit(0);
    }
    // 移动蛇
    map[nx][ny] = 1;
    for (int i = len; i >= 2; i--) {
        map[(map[i-1][0]-1) % (len+1)][(map[i-1][0]-1) / (len+1)] = i;
    }
    map[map[1][0] % (len+1)][map[1][0] / (len+1)] = 0;
}

// 接受键盘输入
void Input() {
    if (kbhit()) {
        char c = getch();
        if (c == 'a' && dx == 0) {
            dx = -1, dy = 0;
        } else if (c == 'd' && dx == 0) {
            dx = 1, dy = 0;
        } else if (c == 'w' && dy == 0) {
            dx = 0, dy = -1;
        } else if (c == 's' && dy == 0) {
            dx = 0, dy = 1;
        }
    }
}

int main() {
    srand(time(NULL));
    InitGame();  // 初始化游戏
    while (1) {
        Show();  // 显示地图和蛇
        Update();  // 更新游戏
        Input();  // 接受键盘输入
        Sleep(200);  // 暂停一段时间
    }
    return 0;
}