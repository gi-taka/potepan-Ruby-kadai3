
#require 'selenium-webdriver'
#初期値
$total_coins = 100
$total_points = 0
$bet_coins = [0, 10, 30, 50]
$point_rate = 10

#スロットの処理
def reset
  $throw_coins = 0
  $player_choice = ""
  $slot_lines = [
    ["","",""],
    ["","",""],
    ["","",""]
    ]
  $hit_flags = [false, false, false]
  $hit_count = 0
end

def throw_coins
  reset
  puts "残りコイン数：#{$total_coins}"
  puts "ポイント：#{$total_points}"
  puts "何コイン入れますか？"
  puts "1(10コイン) 2(30コイン) 3(50コイン) 4(やめる)"
  $player_choice = gets.to_s.chomp
  case $player_choice
    when "1", "2", "3"
      $throw_coins = $bet_coins[$player_choice.to_i]
      if $total_coins >= $throw_coins
        $total_coins -= $throw_coins
        puts "残りコイン数：#{$total_coins}"
        spin_slot
      else
        puts "コインが足りません。"
        throw_coins
      end
    when "4"
      puts "スロットを終了します。"
      end_slot
    else
      puts "無効な値です。選び直してください。"
      throw_coins
  end
end

def spin_slot
  puts "エンターを３回押しましょう！"
  for column in 0..2 do
    gets
    for row in 0..2 do
      $slot_lines[row][column] = Random.rand(1..2)
    end
    $slot_lines.each do |line|
      line.each do |number|
        print "|#{number}"
      end
      puts "|"
    end
    puts "-----------------------"
  end
  slot_result
end

def slot_result
  for row in 0..2 do
    if $slot_lines[row].uniq.count == 1
      $hit_flags[row] = true
      $hit_count += 1
    end
  end
  for flag in 0..2 do
    if $hit_flags[flag] == true
      puts "#{flag + 1}行目に#{$slot_lines[flag][0]}が揃いました。"
      get_coins = $throw_coins * ($hit_count + 1)
      $total_coins += get_coins
      puts "#{get_coins}コインを獲得しました。"
      get_points = $throw_coins * 10
      $total_points += get_points
      puts "#{get_points}ポイントを獲得しました。"
    end
  end
  if $total_coins == 0
    puts "コインがなくなりました。スロットを終了します。"
    end_slot
  else
    throw_coins
  end
end

def end_slot
  puts "結果...最終コイン枚数：#{$total_coins}　獲得ポイント：#{$total_points}"
end

throw_coins
