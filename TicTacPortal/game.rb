require_relative 'ai'


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

        # A tie cannot occur if there are two of the same mark in a row and the opportunity to finish the row (i.e., one turn away from winning.)
        #   Though, there still could be a tie if there is only one empty space and the player is forced to block (checked in next block).
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
          print "|#{i}. #{column}| "
          i += 1
        end
        print "\n"
      end
    end
  end
  class Player
    attr_accessor :current_player

    def initialize
      @game = Game.new
      @game_over = false
    end
    # Sets display name.
    def print_name(name)
      if @game_mark == "AI"
        disp = "Monster" if name == "O"
        disp = "Glados" if name == "X"
      else
        disp = "Test Subject: " + name.to_s
      end
      disp
    end

    # Swaps players
    def assign_player                              
      @game.current_player == "O" ? @game.current_player = "X" : @game.current_player = "O"
    end

    # Swtiches turns if there is no win or tie condition.
    def control(player_choice)                                 
      if @game_over == false
        @game.make_move(@game.current_player, player_choice)   
        if @game.win?                                         
          @game.print_grid
          puts "Congratulations " + print_name(@game.win?) + " gets cake, the loser will not be reformated into cake ingredients."
          @game_over = true
        elsif @game.tie?                             
          @game.print_grid
          puts "It seems that you are both equally dumb. And probably equally flamable."
          @game_over = true
        else                                        
          if @game_mark == "player"                 
            assign_player
            start_turn
          elsif @game_mark == "AI"                   
            
            if @game.current_player == "O"           
              assign_player                     
              @AI.make_move                     
            elsif @game.current_player == "X"   
              assign_player                     
              start_turn                        
            end
          else                                  
            raise "Game mark Error".inspect
          end
        end
      end
    end

    # Start the game session
    def start             
      puts "Welcome to Apeture Science TicTacToe, were we screen the test subjects from the cake ingredients"    
      # Get input from player on game mode
      valid = false
      until valid == true
        puts "To play against another pathetic test \"participant\", press P. If you dare challenge a cyber god, press A, inpudent monster"
        @input = STDIN.gets.chomp.downcase

        valid = "pa".split("")
        if valid.include?(@input)
          valid = true
        else
          puts "Seems you could not manage that simple task. Well at least you can rest assured that you will burn well."
        end
      end
      # Set game mode
      if @input == "p"
        @game_mark = "player"
      elsif @input == "a"
        @AI = AI.new(@game, self)              
        @game_mark = "AI" 
        if @game.current_player == "X"         
          @AI.make_move
        end
      end
      start_turn                               
    end

    # changes turn once valid move is performed and game conditions allow (no Win or Tie) 
    def start_turn                              
      if @game_over == false
        @game.print_grid
        puts "Pick an empty box, " + print_name(@game.current_player) + ". Resitance is futile."
        player_choice = STDIN.gets.chomp        
        valid = "123456789".split("")           
        unless valid.include? player_choice
          puts "Enter a number from 1 to 9, resistance discouraged... with deadly neurotoxin"
          start_turn
        end
        if @game.blank_box?(player_choice)          
          control(player_choice)                    
        else                                        
          puts "That square is taken. Since you cannot see that obvious fact we have taken points off your final grade. If you were not an orphan your family would be ashamed"
          start_turn
        end
      end
    end
  end
end