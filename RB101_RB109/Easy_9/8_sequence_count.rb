def sequence(count, start_num)
  new_arr = []
  current_num = 0
  count.times { new_arr << current_num += start_num }
  new_arr
end

p sequence(5, 1) == [1, 2, 3, 4, 5]
p sequence(4, -7) == [-7, -14, -21, -28]
p sequence(3, 0) == [0, 0, 0]
p sequence(0, 1000000) == []
