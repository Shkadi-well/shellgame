#!/bin/bash

source ./character_movement.sh
source ./cutscence.sh 
source ./first_chapter.sh 
source ./music.sh

# 初始化二维数组的尺寸
rows=10
cols=10

# 创建一个二维数组并初始化为空格
declare -A map # 用于场景绘制

# 场景图层初始化
for ((i=0; i<rows; i++)); do
  for ((j=0; j<cols; j++)); do
    map[$i,$j]="🟨"
  done
done

# 设置人物起始位置
x=0
y=0
new_x=0
new_y=0

# 设置企鹅初始位置
penguin_x=$((rows - 1))
penguin_y=$((cols - 1))

# 保存未被捡起的物品
save_item="🟨"

# 背包系统
declare -a backpack
max_capacity=4

init(){
  # 设置人物起始位置
  x=0
  y=0
  new_x=0
  new_y=0

  # 设置企鹅初始位置
  penguin_x=$((rows - 1))
  penguin_y=$((cols - 1))

  # 场景图层初始化
  for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
      map[$i,$j]="🟨"
    done
  done

  backpack=()  # 清空背包
}

# 读取保存的游戏数据
load_game_data() {
  # 清空背包
  backpack=()

  # 读取数据文件并加载变量
  while IFS='=' read -r key value; do
    case $key in
      rows) rows=$value ;;
      cols) cols=$value ;;
      x) x=$value ;;
      y) y=$value ;;
      new_x) new_x=$value ;;
      new_y) new_y=$value ;;
      save_item) save_item=$value ;;
      max_capacity) max_capacity=$value ;;
      backpack) 
        IFS=',' read -ra backpack <<< "$value" 
        ;;
      *)  # 解析地图数据
        IFS=',' read -r i j <<< "$key"
        map[$i,$j]=$value
        ;;
    esac
  done < ./saved_data.txt

  for i in "${backpack[@]}"; do
    echo $i
  done
  read -p ""
}



# 打印欢迎界面
welcome_screen() {
  # 停止播放当前音乐
  if pgrep mpg123 > /dev/null; then
    stop_music "$music_pid"
  fi
  
   # 启动音乐播放
  music_pid=$(play_music "$SCENE1_MUSIC")
  clear  # 清屏
  
  # 欢迎标题和框架
  echo -e "╔════════════════════════════════════════════════╗"
  echo -e "                 欢迎来到冒险世界!"
  echo -e "╚════════════════════════════════════════════════╝"
  echo

  # 游戏选项框
  echo -e "         ╔══════════════════════════════╗"
  echo -e "                  1. 开始新游戏           "
  echo -e "         ║══════════════════════════════║"
  echo -e "                  2. 读取保存的记录       "
  echo -e "         ║══════════════════════════════║"
  echo -e "                  3. 退出游戏             "
  echo -e "         ╚══════════════════════════════╝"

  echo
  # 用户输入提示
  read -p "请输入选项(1/2/3): " choice

  case $choice in
    1)
      init
      first_chapter  # 进入第一章节
      randomPut  # 初始化游戏场景     
      operation  # 进入游戏主循环
      ;;
    2)
      if pgrep mpg123 > /dev/null; then
        stop_music "$music_pid"
      fi
      load_game_data && operation  # 读取数据并进入游戏
      ;;
    3)
      echo -e "感谢游玩！再见！"
      exit 0
      ;;
    *)
      echo -e "无效的选择，请重新输入！"
      sleep 1
      welcome_screen  # 重新显示欢迎界面
      ;;
  esac
}
# ===================程序执行部分======================
 # 启动音乐播放
music_pid=$(play_music "$SCENE1_MUSIC")
clear  # 清屏

# 启动场景动画
animation

# 启动游戏界面
welcome_screen  
