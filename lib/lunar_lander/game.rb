module LunarLander
  class Game < Chingu::Window
    def initialize
      super
      Gosu::Image.autoload_dirs << File.join(File.expand_path(File.dirname(__FILE__)), "..", "media")
      
      self.input = { :escape => :exit }
      
      @player = Player.create({ :x => width/2, :y => height/2})
      @player.input = {:holding_left => :rotate_left, :holding_right => :rotate_right, :holding_up => :thrust}
    end
  end
end