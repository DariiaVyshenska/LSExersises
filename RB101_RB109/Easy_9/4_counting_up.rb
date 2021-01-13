def sequence(num)
  # (1..num).to_a

  result = (1..num.abs).to_a
  result.map! { |i| i * (-1) } if num.negative?
  result
end

p sequence(5) == [1, 2, 3, 4, 5]
p sequence(3) == [1, 2, 3]
p sequence(1) == [1]
p sequence(-3) == [-1, -2, -3]
