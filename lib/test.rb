# frozen_string_literal:true

# The class that exercises game control
class ConnectFour
  def game_won?
    @rack.winner != 0
  end
end
