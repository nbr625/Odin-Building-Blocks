module TicTacToe
	class Game
		attr_accessor :board
		attr_accessor :curr_player

		def initialize
			@board =
				[["_", "_", "_"],
				["_", "_", "_"],
				["_", "_", "_"]]
			@curr_player = ["O", "X"].sample
		end

		def helper_box_to_coor box 
			box = box.to_i
			x = (box - 1) / 3
			y = (box - 1) % 3
			[x, y]
		end

		def make_move! player, box
			coor = helper_box_to_coor(box)
			@board[coor[0]][coor[1]] = player
		end

		def legal_move? box
			coor = helper_spare_to_coor(box)
			@board[coor[0]][coor[1]] == "_"
		end
		
		def helper_game_state mode 
			board = @board
			total_dots = 0
			dimensions = ["row", "col", "diag_ps", "diag_ns"]

			types = ["X", "O", "_"]

			count = {}
			dimensions.each do |dim|
				count[dim] = {}
				for i in (0..2) do
					count[dim][i] = {}
				end
			end

			board.each do |row|
				row.each do |cell|
					total_dots += 1 if cell == "_"
				end
			end

			types.each do |t|
				["row", "col"].each do |dim|
					for i in (0..2) do
						count[dim][i][t] = board[i].count { |cell| cell == t }
					end
				end
				board = board.transpose
			end

			diag_ps = [board[0][0], board[1][1], board[2][2]]
			diag_ns = [board[0][2], board[1][1], board[2][0]]
			types.each do |t|
				count["diag_ps"][0][t] = diag_ps.count { |cell| cell == t}
				count["diag_ns"][0][t] = diag_ns.count { |cell| cell == t}
			end

			if mode == "wins"
				for i in (0..2) do
					return "X" if count["diag_ps"][0]["X"] == 3 || count["diag_ns"][0]["X"] || count["col"][i]["X"] == 3 || count["row"][i]["X"] == 3
					return "O" if count["diag_ps"][0]["O"] == 3 || count["diag_ns"][0]["O"] || count["col"][i]["O"] == 3 || count["row"][i]["O"] == 3
				end
			elsif mode == "tie"
				return false if total_dots >= 3
				return true if total_dots == 0

				dimensions.each do |dim|
					for i in (0..2) do
						return false if count[dim][i]["X"] == 2 and count[dim][i]["_"] == 1 and @curr_player == "O"
						return false if count[dim][i]["O"] == 2 and count[dim][i]["_"] == 1 and @curr_player == "X"
					end
				end

				return true if total_dots == 2
			elsif mode == "AI"
				return count
			else
				raise "Mode error".inspect
			end

			return false

		end 

		def print_board
			i = 1
			@board.each do |row|
				row.each do |column|
					print "#{i}: #{column}"
					i += 1
				end
				print "\n"
			end
		end
 
		def tie?
			helper_game_state("tie")
		end

		def win?
			helper_game_state("wins")
		end
	end
end
