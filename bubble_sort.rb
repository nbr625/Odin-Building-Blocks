
## Takes an array of numbers and sorts them from lowest to largest
def bubble_sort(array)
  misplaced = array.size - 1
  while misplaced > 0
  	1.upto(misplaced) do |i|
  		if array[i - 1] > array[i]
  			array[i - 1], array[i] = array[i], array[i - 1] #blup, blup
  		end
  	end
  	misplaced -= 1
  end
  print array
end

## Takes an array of strings and sorts them from shortest to longest
def bubble_sort_by(array) 
  misplaced = array.size - 1
  while misplaced > 0
    1.upto(misplaced) do |i|
      if yield(array[i - 1], array[i]) < 0
        array[i - 1], array[i] = array[i], array[i - 1]
      end
    end
    misplaced -= 1
  end
  print array
end

bubble_sort([6, 8, 7, 5, 3, 8, 9])

bubble_sort_by(["this", "sentence", "is", "utter", "nonesense"]) do |left,right|
   right.length - left.length
end