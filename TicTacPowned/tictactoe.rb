
module TicTacToe

  class Game
    attr_accessor :grid, :curr_player

    def initialize
      @grid = [                                  
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
      ]
      @curr_player = ["X", "O"].sample           
    end


    def box_to_coor(box)             
      box = box.to_i
      x_axis = (box-1) / 3
      y_axis = (box-1) % 3
      [x_axis, y_axis]
    end


    


    def make_move(player, box)                
      coor = box_to_coor(box)
      @grid[coor[0]][coor[1]] = player
    end

    def valid_move?(box)                       
      coor = box_to_coor(box)
      @grid[coor[0]][coor[1]] == " "            
    end

    def game_status(game_mode)      
                                              
      grid = @grid                                  
      total_blank = 0  

      dimensions = ["row", "col", "diag_ns", "diag_ps"]                                                  
      marks = ["X", "O", " "]           
      count = {}  

      dimensions.each do |dim|        
        count[dim] = {}
        for i in (0..2) do
          count[dim][i] = {}  
        end
      end

      grid.each do |row|         
        row.each do |sqr|
          total_blank += 1 if sqr == " "
        end
      end

      marks.each do |m|                     
        ["row", "col"].each do |dim|
          for i in (0..2) do
            count[dim][i][m] = grid[i].count { |sqr| sqr == m }
          end
          grid = grid.transpose                    
                                         
        end   
      end 


      diag_ps = [grid[0][2], grid[1][1], grid[2][0]]
      diag_ns = [grid[0][0], grid[1][1], grid[2][2]] 
      
      marks.each do |m|
              
        count["diag_ps"][0][m] = diag_ps.count { |sqr| sqr == m }
      end

      if game_mode == "wins"                       
        for i in (0..2) do                     
          return "X" if count["col"][i]["X"] == 3 || count["row"][i]["X"] == 3 || count["diag_ps"][0]["X"] == 3 || count["diag_ns"][0]["X"] == 3
          return "O" if count["col"][i]["O"] == 3 || count["row"][i]["O"] == 3 || count["diag_ps"][0]["O"] == 3 || count["diag_ns"][0]["O"] == 3
        end

      elsif game_mode == "tie"    

        false if total_blank >= 3                        

       
        
        dimensions.each do |dim|
          for i in (0..2) do
            return false if count[dim][i]["X"] == 2 && count[dim][i][" "] == 1 && @curr_player == "O"
            return false if count[dim][i]["O"] == 2 && count[dim][i][" "] == 1 && @curr_player == "X"
          end
        end

        
        dimensions.each do |dim|
          for i in (0..2) do
            return true if count[dim][i][" "] == 1 && count[dim][i]["O"] == 1 && count[dim][i]["X"] == 1 && total_blank == 1
          end
        end

        true if total_blank == 2   

      elsif game_mode == "AI"                 
        count

      
      else                               
        raise "game_mode error".inspect
      end

      false       
                         
    end

    def tie?                                  
      game_status("tie")
    end


    def win?                                 
      game_status("wins")
    end


    def print_grid              
      i = 1
      @grid.each do |row|
        row.each do |column|
          print "|#{i}. #{column}|"
          i += 1
        end
        print "\n"
      end
    end
  end



  class Player
    attr_accessor :curr_player

    def initialize
      @game = Game.new
      @game_over = false
    end


    def display_name(name)                      
      if @game_type == "AI"
        disp = "Dumb Monkey" if name == "O"
        disp = "Glad0s" if name == "X"
      else
        disp = "Test Subject " + name.to_s
      end
      disp
    end


    def switch_player                               
      @game.curr_player == "O" ? @game.curr_player = "X" : @game.curr_player = "O"
    end


    def results(selection)                                    
      if @game_over == false
        @game.make_move(@game.curr_player, selection) 
        if @game.win?                                 
          @game.print_grid
          puts "Congratulations... " + display_name(@game.win?) + " you get cake. The loser will be reformated into cake ingredients!"
          @game_over = true
        elsif @game.tie?                           
          @game.print_grid
          puts "It seems that you are both equally dumb. And probably equally flamable."
          @game_over = true
        else                                        
          if @game_type == "player"                 
            switch_player
            start_turn
          elsif @game_type == "AI"                  
            
            if @game.curr_player == "O"           
              switch_player                    
              @AI.make_move                   

            elsif @game.curr_player == "X" 
              switch_player            
              start_turn                 
            end

          else                             
            raise "Game Type Error".inspect
          end
        end
      end
    end


    def start_game                         
      puts "Welcome to Apeture Science's least lethal test!"
      
      
      valid = false
      until valid == true
        puts "To play vs another Test Subject press t. To play me, enter \"I am dumb monkey\" and pray to whatever god you believe"
        @input = STDIN.gets.chomp.downcase

        valid = ["t", "i am a dumb monkey"]
        if valid.include?(@input)
          valid = true
        else
          puts "Seems you could not manage that simple task. Well at least you can rest assured that you will burn well."
        end
      end

      
      if @input == "t"
        @game_type = "player"
      elsif @input == "i am a dumb monkey"
        @AI = AI.new(@game, self)                  
        @game_type = "AI" 
        if @game.curr_player == "X"                
          @AI.make_move
        end
      end


      start_turn                                 
    end


    def start_turn                                    
      if @game_over == false
        @game.print_grid
        puts display_name(@game.curr_player) + "Pick a square, resistance is futile"

        selection = STDIN.gets.chomp                     
        
        valid = "123456789".split("")                   
        unless valid.include? selection
          puts "Enter a number from 1 to 9, resistance is futile"
          start_turn
        end

        if @game.valid_move?(selection)     
          results(selection)                         
        else                                           
          puts "That square is taken. Since you cannot see that obvious fact we have taken points off your final grade. If you were not an orphan your family would be ashamed"
          start_turn
        end
      end
    end
  end
end



