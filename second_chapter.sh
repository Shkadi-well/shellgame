# the second chapter of the game


second_chapter() {
 # 使用 figlet 和 lolcat 渐显游戏标题
    stop_music "$music_pid1"
    clear
    echo -e "\n\n\n\n"  # 添加一些空行，为标题留出空间
    figlet -w 150 "Fresh start" | lolcat -d 50  # -d 50 控制彩虹色变化的延迟时间
    echo "由于时间原因，本游戏暂时停止更新，敬请期待下一版！"
    read -p ""
    exit 0
}
