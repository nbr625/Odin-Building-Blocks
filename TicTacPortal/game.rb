require_relative 'glad0s'
require_relative 'player'
require_relative 'color'

module Session

  class Game
    attr_accessor :grid, :current_player

    def initialize
      @grid =  [                               
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
      ]
      @current_player = ["O", "X"].sample          
    end

    # Locates the right box using the x and y axis
    def locate(point)                 
      point = point.to_i
      x = (point-1) / 3
      y = (point-1) % 3
      [x, y]
    end

    # Validates that the space is empty.
    def blank_box?(point)                         
      co = locate(point)
      @grid[co[0]][co[1]] == " "               
    end

    # Marks Move with player symbol
    def make_move(player, point)                     
      co = locate(point)
      @grid[co[0]][co[1]] = player
    end

    # Checks for a tie
    def tie?                                    
      game_status("tie")
    end

    # Checks for a win
    def win?                                
      game_status("wins")
    end

    # Determines the wheter their is a win of tie conditon
    def game_status(mode)      
                               
      grid = @grid             
      blank_total = 0
      dimensions = ["row", "col", "diag_ns", "diag_ps"]  
      # diag_ps: positive-slope diagonal, diag_ns: negative-slope  diagonal    
      diag_ps = [grid[0][2], grid[1][1], grid[2][0]]
      diag_ns = [grid[0][0], grid[1][1], grid[2][2]]

      marks = ["X", "O", " "]  
      
      # Stores marks and dimensions
      count = {}                            
      dimensions.each do |dim|          
        count[dim] = {}
        for i in (0..2) do
          count[dim][i] = {}  
        end
      end

      # Count blank total
      grid.each do |row|                  
        row.each do |square|
          blank_total += 1 if square == " "
        end
      end
      # Count the number of that mark along dimensions, ".transpose" is used to count columns
      #   It is then reverted to its original form at the end of the block.
      marks.each do |t|                                 
        ["row", "col"].each do |dim|
          for i in (0..2) do
            count[dim][i][t] = grid[i].count { |square| square == t }
          end
          grid = grid.transpose                     
        end   
      end 
      #counts diagonals
      marks.each do |m|
        count["diag_ns"][0][m] = diag_ns.count { |square| square == m }      
        count["diag_ps"][0][m] = diag_ps.count { |square| square == m }
      end
      # Determines whether someone won and who.
      if mode == "wins"                                
        for i in (0..2) do   
          # Win for rows and columns                          
          return "X" if count["row"][i]["X"] == 3 || count["col"][i]["X"] == 3 
          return "O" if count["row"][i]["O"] == 3 || count["col"][i]["O"] == 3
          # Wins for diagonals
          return "X" if count["diag_ns"][0]["X"] == 3 || count["diag_ps"][0]["X"] == 3
          return "O" if count["diag_ns"][0]["O"] == 3 || count["diag_ps"][0]["O"] == 3
        end
      # Tie condtions
      elsif mode == "tie"                     
        # if two spots are empty there can be no tie.
        #   if there are no spots left, tie.
        return false if blank_total >= 2               
        return true if blank_total == 0                

        # A tie cannot occur if there are two of the same mark in a row.
        dimensions.each do |dim|
          for i in (0..2) do
            return false if count[dim][i]["X"] == 2 and count[dim][i][" "] == 1 and @current_player == "O"
            return false if count[dim][i]["O"] == 2 and count[dim][i][" "] == 1 and @current_player == "X"
          end
        end
        # A tie if there is only one blank box and no two marks advacent to one another.
        dimensions.each do |dim|
          for i in (0..2) do
            return true if count[dim][i][" "] == 1 and count[dim][i]["O"] == 1 and count[dim][i]["X"] == 1 and blank_total == 1
          end
        end
        # All other conditions point to a tie.
        return true if blank_total == 1             
      #AI requests hash, so it does not need to be written again.
      elsif mode == "AI"               
        return count
      else    
        # if there is not win or tie an error is raised
        raise "Mode error".inspect
      end
      return false                                                                                        
    end
    # Print the playing grid
    def print_grid
      i = 1
      @grid.each do |row|
        row.each do |column|
          print blue("|") + blue(i) + ". " + pink(column) + pink("|")
          i += 1
        end
        print "\n"
      end
    end
  end
end