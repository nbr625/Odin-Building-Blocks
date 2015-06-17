module TicTacToe
class AI
    def initialize game, player
      @game = game                                 
      @player = player
    end


    def make_move
      puts "Behold my superior intelligence, human."
      move = tactics
      if @game.blank_box?(move)
        @player.control(move)
        move_made = true
      else
        raise "AI Error".inspect                     
      end
    end
    
    def tactics   
      grid = @game.grid
      dimensions = ["row", "col", "diag_ns", "diag_ps"]
      count = @game.game_status("AI")
      
      blank_total = 0
      # Tabulates total blank boxes, used to determine best strategy.
      grid.each do |row|
        row.each do |square|
          blank_total += 1 if square == " "
        end
      end

      # Picks corner to potentially set up an ambush on the opposite corner.
      #  usually an unforseen strategy for beginners.
      return [1, 3, 7, 9].sample if blank_total == 9

      
      #  Blocks edges if the opponent has a clear win.
      select = false
      dimensions.each do |dim|                 
        for i in (0..2) do
          select = [dim, i] if count[dim][i]["O"] == 2 && count[dim][i][" "] == 1
        end
      end
      if select                               
        if select[0] == "row"
          for i in (0..2) do
            return select[1]*3 + i + 1 if grid[select[1]][i] == " "
          end
        elsif select[0] == "col"
          for i in (0..2) do
            return i * 3 + select[1] + 1 if grid[i][select[1]] == " "
          end
        elsif select[0] == "diag_ns"
          for i in (0..2) do
            return i * 3 + i+1 if grid[i][i] == " "
          end
        elsif select[0] == "diag_ps"
          for i in (0..2) do
            return i * 3 + 2 - i + 1 if grid[i][2 - i] == " "
          end
        end
      end

      s1 = grid[0][0] #1 - Top Left                 ____ ____ ____
      s2 = grid[0][1] #2 - Top Middle              | s1 | s2 | s3 |
      s3 = grid[0][2] #3 - Top Bottom               ---- ---- ----           
      s4 = grid[1][0] #4 - Middle Left             | s4 | s5 | s6 |   
      s5 = grid[1][1] #5 - Dead center              ---- ---- ----
      s6 = grid[1][2] #6 - Middle Right            | s7 | s8 | s9 |
      s7 = grid[2][0] #7 - Bottom Left              ---- ---- ----
      s8 = grid[2][1] #8 - Bottom Center
      s9 = grid[2][2] #9 - Bottom Right

      # Blocks middle position in a dimension if opponent has a clear win.
      return 6 if (s3 == "O" && s7 == "O") || (s1 == "O" && s9 == "O") && s6 == " " && @game.blank_box?(6) 
      return 4 if (s3 == "O" && s7 == "O") || (s1 == "O" && s9 == "O") && s5 == " " && @game.blank_box?(4)
      return 2 if (s3 == "O" && s7 == "O") || (s1 == "O" && s9 == "O") && s8 == " " && @game.blank_box?(2)
      return 8 if (s3 == "O" && s7 == "O") || (s1 == "O" && s9 == "O") && s2 == " " && @game.blank_box?(8)

      # AI comples the dimension && wins.
      select = false
      dimensions.each do |dim|                       
        for i in (0..2) do
          select = [dim, i] if count[dim][i]["X"] == 2 && count[dim][i][" "] == 1
        end
      end
      if select                          
        if select[0] == "row"
          for i in (0..2) do
            return select[1] * 3 + i + 1 if grid[select[1]][i] == " "
          end
        elsif select[0] == "col"
          for i in (0..2) do
            return i * 3 + select[1] + 1 if grid[i][select[1]] == " "
          end
        elsif select[0] == "diag_ps"
          for i in (0..2) do
            return i * 2 - i + 1 if grid[i][2 - i] == " "
          end
        end
        elsif select[0] == "diag_ns"
          for i in (0..2) do
            return i * 3 + i + 1 if grid[i][i] == " "
          end  
      end


      # Sets up in corner ambush.
      #   ____ ____ ____
      #  |  X |    |    |
      #   ---- ---- ----
      #  |    | O  |    |
      #   ---- ---- ----
      #  |    |    |  X |
      #   ---- ---- ----
      return 9 if s1 == "X" && s5 == "O" && @game.blank_box?(9)
      return 7 if s3 == "X" && s5 == "O" && @game.blank_box?(7)
      return 3 if s7 == "X" && s5 == "O" && @game.blank_box?(3)
      return 1 if s9 == "X" && s5 == "O" && @game.blank_box?(1)
      # Takes adjacent corner if available.
      return 3 if s1 == "X" && s9 == "O" && @game.legal_move?(3)
      return 7 if s1 == "X" && s9 == "O" && @game.legal_move?(7)
      return 1 if s3 == "X" && s7 == "O" && @game.legal_move?(1)
      return 9 if s3 == "X" && s7 == "O" && @game.legal_move?(9)
      return 1 if s7 == "X" && s3 == "O" && @game.legal_move?(1)
      return 9 if s7 == "X" && s3 == "O" && @game.legal_move?(9)
      return 3 if s9 == "X" && s1 == "O" && @game.legal_move?(3)
      return 7 if s9 == "X" && s1 == "O" && @game.legal_move?(7)

      # Takes Center if its not the start of the turn.
      return 5 if s5 == "." && @game.valid_move?(5) && total_blanks < 9

      # Takes opposite corner.
      return 9 if s1 == "O" && @game.blank_box?(9)
      return 7 if s3 == "O" && @game.blank_box?(7)
      return 3 if s7 == "O" && @game.blank_box?(3)
      return 1 if s9 == "O" && @game.blank_box?(1)

      # Takes a corner.
      return 1 if @game.blank_box?(1)
      return 3 if @game.blank_box?(3)
      return 7 if @game.blank_box?(7)
      return 9 if @game.blank_box?(9)

      # Takes a side.
      return 2 if @game.blank_box?(2)
      return 4 if @game.blank_box?(4)
      return 6 if @game.blank_box?(6)
      return 8 if @game.blank_box?(8)

      raise "Move error".inspect      
    end
  end
end

      tl = grid[0][0] #1 - Top Left
      tc = grid[0][1] #2 - Top Middle
      tr = grid[0][2] #3 - Top Bottom

      ml = grid[1][0] #4 - Middle Left
      mc = grid[1][1] #5 - Dead Center
      mr = grid[1][2] #6 - Middle Right

      bl = grid[2][0] #7 - Bottom Left
      bc = grid[2][1] #8 - Bottom Center
      br = grid[2][2] #9 - Bottom Right

      
      # Stratagems
      #  Sets up in corner ambush 
      return 9 if tl == "X" && mc == "O" && @game.blank_box?(9)
      return 7 if tr == "X" && mc == "O" && @game.blank_box?(7)
      return 3 if bl == "X" && mc == "O" && @game.blank_box?(3)
      return 1 if br == "X" && mc == "O" && @game.blank_box?(1)

      # If opponent owns the opposite corner, swith strategy
      #  takes center to 
      return 5 if tl == "X" && br == "O" && @game.blank_box?(5)
      return 5 if tr == "X" && bl == "O" && @game.blank_box?(5)
      return 5 if bl == "X" && tr == "O" && @game.blank_box?(5)
      return 5 if br == "X" && tl == "O" && @game.blank_box?(5)
      


      
      return 5 if mc == " " && @game.blank_box?(5) && blank_total < 9


      
      return 9 if tl == "O" && @game.blank_box?(9)
      return 7 if tr == "O" && @game.blank_box?(7)
      return 3 if bl == "O" && @game.blank_box?(3)
      return 1 if br == "O" && @game.blank_box?(1)


      
      return 1 if @game.blank_box?(1)
      return 3 if @game.blank_box?(3)
      return 7 if @game.blank_box?(7)
      return 9 if @game.blank_box?(9)


      raise "Move error".inspect    