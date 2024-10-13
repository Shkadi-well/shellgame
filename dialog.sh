# dialog.sh

# 引入外部文件
source ./coordinate.sh

# 全局变量记录接触次数
touch_count=0

# 🐧 👦
penguin_dialog() {
    ((touch_count++))  # 记录接触次数

    if [[ $touch_count -eq 1 ]]; then
        # 第一次接触
        echo "(为什么森林里会有企鹅啊？😮)"
        echo "你走上前去，想要打听一下情况。"

        while true; do
            read -p "你想和企鹅怎样打招呼?: 1: “嗨你好，这是哪啊？” 2: 摸一摸他的头 3: 不想聊了  " choice
            case $choice in
                1) 
                    echo "👦：嗨你好，这是哪啊?"
                    read -p ""
                    echo "🐧：你干嘛！（不耐烦）"
                    read -p ""
                    echo "👦：我第一次来，请问这是哪，怎么离开这里啊？"
                    read -p ""
                    echo "🐧：你想从我这里得到消息，那不得给我点好处。"
                    read -p ""
                    if [[ ${#backpack[@]} -eq 0 ]]; then
                        echo "你的背包是空的，无法给出物品。"
                        return
                    fi
                    give_penguin_item  # 调用选择物品的函数
                    break
                    ;;
                2) 
                    echo "你一个箭步上前，开始薅企鹅的毛。"
                    echo "🐧：神金冰吧"
                    echo "企鹅一个闪现不见了踪影"
                    Change_Coordinate new_x new_y
                    read -p ""
                    echo "👦：他刚刚是前后鼻发错了吧"
                    echo "无论如何你决定还是再找找他"
                    read -p ""
                    break
                    ;;
                3) 
                    break 
                    ;;
                *) 
                    echo "如你所见，你没有选择其他的权力" 
                    read -p ""
                    ;;
            esac
        done
    else
        echo "再次遇见企鹅，你收敛许多"
        echo "👦：企鹅兄，我知错了，你可以带我离开吗？"
        read -p ""
        echo "🐧：那得给点什么好处,比如钻石~"
        give_penguin_item  # 调用选择物品的函数
    fi
}

give_penguin_item() {
    # 玩家选择物品
    tag=0
    while [ $tag -eq 0 ]; do
        # 列出背包中的物品
        echo "你翻开背包，选择给企鹅的物品："
        for i in "${!backpack[@]}"; do
            echo "$((i + 1)). ${backpack[$i]}"
        done

        read -p "请选择要给企鹅的物品编号: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -le "${#backpack[@]}" ]; then
            # 获取选中的物品
            local selected_item="${backpack[$((choice - 1))]}"
            echo "你选择了 $selected_item 给企鹅。"

            # 根据物品触发不同的对话逻辑
            case $selected_item in
                "🌼"|"🍃"|"🪵")
                    echo "🐧：这片森林哪里找不到 $selected_item。"
                    read -p ""
                    ;;
                "🍎")
                 echo "🐧：苹果，这种东西我可不稀罕。"
                    read -p ""
                    ;;
                "💎")
                    echo "🐧：那行吧，我也不让你吃亏，我回答你的问题，还送你一个砧板和一把菜刀。"
                    read -p ""
                    echo "👦：我一个钻石就换了两个问题，加一个砧板。这也太亏了吧。"
                    read -p ""
                    echo "🐧：行吧，行吧。（不耐烦地摆摆手）那就再给你6块钱吧。"
                    read -p ""
                    echo "👦：才6块钱，这也太抠了吧。"
                    read -p ""
                    echo "🐧：爱要要，不要拉倒。别拿你们人类的物价来衡量我们世界啊？这钱你不要我就拿回去了。"
                    read -p ""
                    echo "难道在这里6块钱很值钱？你想了想"
                    read -p ""
                    echo "👦：别别别，这钱我要了。求你帮帮忙吧。"
                    read -p ""
                    echo "接着企鹅回答了你的问题，并将你带出了森林，安置在了一件房子里。"
                    read -p ""
                    tag=1
                    flag=1
                    ;;
                *)
                    echo "🐧：这东西我不感兴趣。"
                    read -p ""
                    ;;
            esac
        
            # 移除背包中的物品
            unset backpack[$((choice - 1))]
            backpack=("${backpack[@]}")  # 重新整理数组，删除空元素

            # 更新地图和背包显示
            print_map  # 重新绘制地图和背包内容
        else
            echo "无效选择！"
        fi
    done
}
