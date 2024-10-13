#!/bin/bash
#!/bin/bash
source ./Character_movement.sh 
source ./cutscence.sh 
source ./first_chapter.sh 

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

# 读取保存的游戏数据
load_game_data() {
  check_game_data || return  # 如果数据文件不存在，则返回

  # 清空背包
  unset backpack

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
      backpack) IFS='(' read -ra backpack <<< "$value" ;;
      *)  # 解析地图数据
        IFS=',' read -r i j <<< "$key"
        map[$i,$j]=$value
        ;;
    esac
  done < ./saved_data.txt
}


# 打印欢迎界面
welcome_screen() {
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
 
      animation  # 游戏开始动画
      randomPut  # 初始化游戏场景
      first_chapter  # 进入第一章节
      main  # 进入游戏主循环
      ;;
    2)
      load_game_data && main  # 读取数据并进入游戏
      ;;
    3)
      echo -e "感谢游玩！再见！"
      exit 0
      ;;
    *)
      echo -e "${RED}无效的选择，请重新输入！"
      sleep 1
      welcome_screen  # 重新显示欢迎界面
      ;;
  esac
}

# 游戏数据检查
check_game_data() {
  if [[ ! -f ./saved_data.txt ]]; then
    echo -e "${RED}没有找到保存的记录文件！"
    sleep 2
    return 1  # 返回错误状态
  fi
  return 0  # 正常返回
}

# ===================程序执行部分======================
welcome_screen  # 启动游戏界面
