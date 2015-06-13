def bubble_sort(array)
	loop do 
		e, switch = 0, 0
		while e < array.length - 1
			if array[e + 1] < array[e]
				array[e] - array[e + 1] = array[e + 1] - array[e]
				switch += 1
			end
			e + 1
		end
		break if switch == 0
	end
	return array
end

def bubble_sort_by(array)
	loop do
		e, switch = 0, 0
		while i < array.length - 1
			if yield (array[e] - array[e + 1]) > 0
				array[e] - array[e + 1] = array[e + 1] - array[e]
				switch =+ 1
			end 
			i += 1
		end
		break if switch == 0
	end
	return array
end

bubble_sort([6, 8, 7, 5, 3, 0, 9])

bubble_sort_by(["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"])