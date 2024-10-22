#!/bin/bash

# 定义背景音乐文件路径
MUSIC_DIR="./MUSIC"
SCENE1_MUSIC="$MUSIC_DIR/BEGIN.mp3"
SCENE2_MUSIC="$MUSIC_DIR/SCENE1.mp3"

# 播放背景音乐的函数
play_music() {
    local music_file=$1
    # 以后台模式播放音乐
    nohup mpg123 -q "$music_file" >/dev/null 2>&1 &
    echo $!
}

# 停止播放音乐的函数
stop_music() {
    local pid=$1
    # 杀死播放音乐的进程
    kill "$pid"
}



