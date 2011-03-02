module LunarLander
  class Game < Chingu::Window
    def initialize
      super(800,600)
      Gosu::Image.autoload_dirs << File.join(File.expand_path(File.dirname(__FILE__)), "..", "media")
      Gosu::Sound.autoload_dirs << File.join(File.expand_path(File.dirname(__FILE__)), "..", "media")
      
      self.input = { :escape => :exit }
      push_game_state(LunarLander::Play)
    end
  end
end