#!/bin/bash

# 初始化二维数组的尺寸
rows=10
cols=10

# 创建一个二维数组并初始化为空格

declare -A map #用于场景绘制

# 场景图层初始化
for ((i=0; i<rows; i++)); do
  for ((j=0; j<cols; j++)); do
    map[$i,$j]="🟨"
  done
done

# 设置起始位置
x=0
y=0
new_x=0
new_y=0
map[$x,$y]="👦"  # 人物的初始位置

# 保存未被捡起的物品
save_item="🟨"

# 背包系统
declare -a backpack
max_capacity=4

# 随机放置元素
for ((i=0; i<rows; i++)); do
  for ((j=0; j<cols; j++)); do
    rand=$(( RANDOM % 100 ))  # 生成 0-99 的随机数
    if (( rand < 20 )); then
      map[$i,$j]="🌳"  # 20% 概率放置树木
    elif (( rand < 40 )); then
      map[$i,$j]="🌼"  # 20% 概率放置花
    elif (( rand < 45 )); then
      map[$i,$j]="🪵"  # 5% 概率放置原木
    elif (( rand < 50 )); then
      map[$i,$j]="🍃"  # 5% 概率放置树叶
    elif (( rand < 51 )); then
      map[$i,$j]="🍎"  # 1% 概率放置苹果
    elif (( rand < 52 )); then
      map[$i,$j]="💎"  # 1% 概率放置钻石
    fi
  done
done

# 函数：打印数组
print_map() {
  clear
  echo "========= 游戏地图 =========="
  for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
      echo -n "${map[$i,$j]} "  # 打印场景图层
    done
    echo
  done
  
  echo "当前位置: ($x, $y)"
  echo "背包: ${backpack[@]:-"空"}"  # 显示背包内容
  echo "============================="
}

check_item() {
  if [[ ${map[$new_x,$new_y]} == "🌳" ]]; then
    # 如果遇到树，则不移动
    new_x=$x
    new_y=$y
    save_item=${map[$new_x,$new_y]}
  else 
    # 移动到新位置
    x=$new_x
    y=$new_y
    if [[ ${map[$new_x,$new_y]} != "🟨" ]]; then 
      read -p "你遇到了 ${map[$new_x,$new_y]}, 是否拾起? (yes/no): " answer
      if [[ "$answer" == "yes" ]]; then 
        pick_item ${map[$new_x,$new_y]} # 进行捡起操作
      fi
    fi
  fi
}



pick_item() {
  local item="$1"  # 读取物品名称
  if [[ ${#backpack[@]} -lt $max_capacity ]]; then
    backpack+=("$item")  # 添加物品到背包
    echo "$item 已加入背包！"
    map[$x,$y]="🟨"  # 清空当前位置的物品
    save_item="🟨"
  else
    echo "背包已满，无法拾取 $item!"
    read -p "是否丢弃背包中其他物品?(yes/no),并拾取 $item!" answer
    if [[ "$answer" == "yes" ]]; then
      # 列出背包中的物品
      echo "背包中的物品:"
      for i in "${!backpack[@]}"; do
        echo "$((i + 1)). ${backpack[$i]}"
      done

      read -p "请选择需要丢弃的物品编号: " choice
      # 检查输入的有效性
      if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -le "${#backpack[@]}" ]; then
        # 将选中的物品丢弃并用新的物品替换
        local discarded_item="${backpack[$((choice - 1))]}"
        backpack[$((choice - 1))]="$item"  # 替换物品
        map[$x,$y]="🟨"  # 清空当前位置的物品
        # 重新放置被丢弃的物品
        map[$x,$y]="$discarded_item"
        save_item=${map[$x,$y]}
        echo "$discarded_item 已丢弃,$item 已加入背包!"        
      fi
    else
      save_item=$item
    fi
  fi
}

# 函数：移动上
move_up() {
  if ((x > 0)); then
    map[$x,$y]=$save_item  # 清空原位置
    ((new_x--))
    save_item=${map[$new_x,$new_y]}
    check_item
    map[$x,$y]="👦"  # 更新新位置
  fi
}

# 函数：移动下
move_down() {
  if ((x < rows - 1)); then
    map[$x,$y]=$save_item  # 清空原位置
    ((new_x++))
    save_item=${map[$new_x,$new_y]}
    check_item
    map[$x,$y]="👦"  # 更新新位置
  fi
}

# 函数：移动左
move_left() {
  if ((y > 0)); then
    map[$x,$y]=$save_item  # 清空原位置
    ((new_y--))  
    save_item=${map[$x,$new_y]}  
    check_item
    map[$x,$y]="👦"  # 更新新位置
  fi
}

# 函数：移动右
move_right() {
  if ((y < cols - 1)); then
    map[$x,$y]=$save_item  # 清空原位置
    ((new_y++))  
    save_item=${map[$x,$new_y]}  
    check_item
    map[$x,$y]="👦"  # 更新新位置
  fi
}


# ==========================以下为主函数部分==========================

# 初始绘制
print_map

# 移动元素
while true; do
  read -n1 -s -p "使用 W/A/S/D 移动,Q 退出: " move
  echo  # 换行
  new_x=$x
  new_y=$y
  case $move in
    w) move_up ;;  # 上
    a) move_left ;;  # 左
    s) move_down ;;  # 下
    d) move_right ;;  # 右
    q) break ;;  # 退出
    *) echo "无效的输入!" ;;  # 无效输入
  esac
  print_map
done


