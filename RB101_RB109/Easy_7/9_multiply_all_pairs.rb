def multiply_all_pairs(arr1, arr2)
  new_arr = []
  arr1.each do |a|
    arr2.each { |b| new_arr << a * b}
  end
  new_arr.sort
end

p multiply_all_pairs([2, 4], [4, 3, 1, 2]) == [2, 4, 4, 6, 8, 8, 12, 16]
