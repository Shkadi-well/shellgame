#!/bin/bash

颜色设置
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

# 动态加载动画
loading_animation() {
  echo -ne "${YELLOW}加载中"
  for i in {1..5}; do
    echo -ne "."
    sleep 0.3
  done
  echo -e "${RESET}"
}

# 打印进度条
progress_bar() {
  echo -ne "${GREEN}启动中: ["
  for i in {1..20}; do
    echo -ne "■"
    sleep 0.1
  done
  echo -e "]${RESET} 完成！"
  sleep 1
}

# 打印欢迎界面
welcome_screen() {
  clear  # 清屏

  # 获取终端宽度
  term_width=$(tput cols)

  # 辅助函数：居中打印
  print_centered() {
    local text="$1"
    printf "%*s\n" $(((${#text} + term_width) / 2)) "$text"
  }

  # 欢迎标题和框架
  echo -e "${CYAN}╔════════════════════════════════════════════════╗${RESET}"
  print_centered "${BOLD}${YELLOW}欢迎来到${GREEN} 冒险世界 ${YELLOW}！${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════════════╝${RESET}"
  echo

  # 游戏LOGO展示（企鹅示例）
  print_centered "   ${BLUE}❄️🐧❄️${RESET}  "
  sleep 1

  # 游戏选项框
  print_centered "${CYAN}┌──────────────────────────────┐${RESET}"
  print_centered "${CYAN}│  ${GREEN}1.${RESET} 开始新游戏             ${CYAN}│${RESET}"
  print_centered "${CYAN}├──────────────────────────────┤${RESET}"
  print_centered "${CYAN}│  ${GREEN}2.${RESET} 读取保存的记录         ${CYAN}│${RESET}"
  print_centered "${CYAN}├──────────────────────────────┤${RESET}"
  print_centered "${CYAN}│  ${GREEN}3.${RESET} 退出游戏               ${CYAN}│${RESET}"
  print_centered "${CYAN}└──────────────────────────────┘${RESET}"

  echo
  # 用户输入提示
  read -p "${YELLOW}请输入选项(1/2/3): ${RESET}" choice

  case $choice in
    1)
      loading_animation  # 加载动画
      progress_bar  # 打印进度条
      animation  # 游戏开始动画（在Character_movements.sh中定义）
      randomPut  # 初始化游戏场景
      first_chapter  # 进入第一章节
      main  # 进入游戏主循环
      ;;
    2)
      load_game_data && main  # 读取数据并进入游戏
      ;;
    3)
      echo -e "${CYAN}感谢游玩！再见！${RESET}"
      exit 0
      ;;
    *)
      echo -e "${RED}无效的选择，请重新输入！${RESET}"
      sleep 1
      welcome_screen  # 重新显示欢迎界面
      ;;
  esac
}

# 游戏数据检查
check_game_data() {
  if [[ ! -f ./saved_data.txt ]]; then
    echo -e "${RED}没有找到保存的记录文件！${RESET}"
    sleep 2
    return 1  # 返回错误状态
  fi
  return 0  # 正常返回
}

# 读取保存的游戏数据
load_game_data() {
  check_game_data || return  # 如果数据文件不存在，则返回

  unset backpack  # 清空背包

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
      backpack) IFS='(' read -ra backpack <<< "$value" ;;
      *)  # 解析地图数据
        IFS=',' read -r i j <<< "$key"
        map[$i,$j]=$value
        ;;
    esac
  done < ./saved_data.txt
}

# ===================程序执行部分======================
welcome_screen  # 启动游戏界面
