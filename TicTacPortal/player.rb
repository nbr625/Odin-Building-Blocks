
module Session

class Player
    attr_accessor :current_player

    def initialize
      @game = Game.new
      @game_over = false
    end
    # Sets display name.
    def print_name(name)
      if @game_mark == "AI"
        disp = pink("Monster") if name == "O"
        disp = blue("Glados") if name == "X"
      else
        disp = blue("Test Subject: " + name.to_s)
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
          puts  print_name(@game.win?) + " gets " +  pink("cake") + ", the loser will not be " + pink("reformated into cake ingredients.")
          @game_over = true
        elsif @game.tie?                             
          @game.print_grid
          puts "It seems that you are both " + pink("equally dumb") + ". And probably " + pink("equally flamable.")
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
      puts "Welcome to " + blue("Apeture Science TicTacToe") + ", were we screen the test " + blue("test subjects") + " from the " + pink("cake ingredients")    
      # Get input from player on game mode
      valid = false
      until valid == true
        puts "To play against another pathetic test \"participant\", " + blue("press P") + ". If you dare challenge a cyber god, " + blue("press A") + ". On a relevant note, " + pink("please don't spill tears into any Apeture Science equipement.")
        @input = STDIN.gets.chomp.downcase

        valid = "pa".split("")
        if valid.include?(@input)
          valid = true
        else
          puts "Seems you could not manage that simple task. Well at least you can rest assured that " + pink("you will burn well.")
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
        puts "Pick an empty box, " + print_name(@game.current_player) + ". Resitance is " + pink("futile.")
        player_choice = STDIN.gets.chomp        
        valid = "123456789".split("")           
        unless valid.include? player_choice
          puts "Enter a number from " + pink("1 to 9") + ", resistance discouraged... with " + pink("deadly neurotoxin")
          start_turn
        end
        if @game.blank_box?(player_choice)          
          control(player_choice)                    
        else                                        
          puts blue("That square is taken") + ". Since you cannot see that obvious fact we have taken points off your " + blue("final grade") + ". If you were not an " + pink("orphan") + " your family would be ashamed"
          start_turn
        end
      end
    end
  end
end