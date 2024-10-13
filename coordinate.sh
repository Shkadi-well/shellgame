# coordinate.sh

Change_Coordinate() {
    # 物品新位置初始化为原位置
    local new_Qx=-1
    local new_Qy=-1

    # 以人物为中心，遍历周围位置，传送企鹅
    local directions=(
        "-1 0","1,0"
        "0,-1","0,1"
        "-1,-1","1,1"
        "1,-1","-1,1"
    )

    flag=0
    find_x=$new_x
    find_y=$new_y
    
    queue=("$find_x,$find_y")

    while [[ ${#queue[@]} -gt 0 ]]; do
        # 取出队列中的第一个位置
        current=${queue[0]}
        queue=("${queue[@]:1}") # 删除第一个元素

        # 拆解当前坐标
        current_x=$(echo $current | cut -d "," -f 1)
        current_y=$(echo $current | cut -d "," -f 2)

        # 检查当前坐标是否在地图范围内
        if [[ $current_x -ge 0 && $current_x -lt $rows && $current_y -ge 0 && $current_y -lt $cols ]]; then
            if [[ ${map[$current_x,$current_y]} == "🟨" ]]; then
                new_Qx=$current_x
                new_Qy=$current_y
                flag=1
                break
            fi

            # 如果没找到，则继续扩展
            for direction in "${directions[@]}"; do
                dx=$(echo $direction | cut -d " " -f 1)
                dy=$(echo $direction | cut -d " " -f 2)
                next_x=$((current_x+dx))
                next_y=$((current_y+dy))

                # 添加下一个位置到队列
                queue+=("$next_x,$next_y")
            done
        fi
    done

    # 检查是否找到了新的空白位置
    if [[ $new_Qx -eq -1 || $new_Qy -eq -1 ]]; then
        echo "没有找到新的空白位置，无法移动企鹅。"
        return
    fi
    map[$new_x,$new_y]="🟨"
    
    # 将企鹅放置到新的位置
    map[$new_Qx,$new_Qy]="🐧"
}

