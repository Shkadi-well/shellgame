# save game data

# 退出游戏函数
quit(){
  echo "是否保存"
  read -p "是否保存?(y/n): " answer
  if [[ "$answer" == "yes" ]]; then
    #写入文件
    save_game_data
    echo "保存成功!"
    
  elif [[ "$answer" == "no" ]]; then
    echo "未保存"
    
    
  fi  
    echo "退出游戏!"
    exit 0
}

# 保存文件函数
save_game_data() {
  # 构建数据字符串
  local data_string=""
  data_string+="rows=$rows\n"
  data_string+="cols=$cols\n"
  data_string+="x=$x\n"
  data_string+="y=$y\n"
  data_string+="new_x=$new_x\n"
  data_string+="new_y=$new_y\n"
  data_string+="save_item=$save_item\n"
  data_string+="max_capacity=$max_capacity\n"
  data_string+="backpack=${backpack[@]}\n"

  # 保存地图数据
  for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
      data_string+="$i,$j=${map[$i,$j]}\n"
    done
  done

  # 保存到文件
  echo -e "$data_string" > ./save_data.txt
}