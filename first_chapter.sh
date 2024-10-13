# first chapter of the game

first_chapter() {
 # 使用 figlet 和 lolcat 渐显游戏标题
    echo -e "\n\n\n\n"  # 添加一些空行，为标题留出空间
    figlet "Adventure in the woods" | lolcat -d 50  # -d 50 控制彩虹色变化的延迟时间
}