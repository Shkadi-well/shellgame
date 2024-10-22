# This file is used to generate the cutscene of the game.

animation(){
    # 函数：淡出效果
    fade_out() {
    for i in {1..5}; do
        echo -e "\n\n\n\n\n\n\n\n\n\n\n\n"  # 添加空行，逐渐清除屏幕内容
        sleep 0.5  # 设置每次淡出的间隔时间，值越大淡出越慢
    done
    }

    # 运行 cmatrix 作为背景动画，持续 5 秒
    cmatrix  -b -u 10 &  # -b表示粗体字体，-u控制更新速度 
    sleep 5  # 等待5秒

    # 开始淡出 cmatrix 动画
    fade_out
    killall cmatrix  # 结束 cmatrix
}