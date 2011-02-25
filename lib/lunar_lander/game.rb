module LunarLander
  class Game < Chingu::Window
    def initialize
      super
      self.input = { :escape => :exit }
      
      @player = Player.create({ :x => width/2, :y => height/2})
      @player.input = {:holding_left => :rotate_left, :holding_right => :rotate_right, :holding_up => :thrust}
    end
  end
end