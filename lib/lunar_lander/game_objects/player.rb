module LunarLander
  class Player < Chingu::GameObject
    trait :velocity
    
    def initialize(options={})
      super(options.merge(:image => Gosu::Image["player.png"]))
    end
    
    def setup
      self.acceleration_y = 0.01
      self.velocity_y = 1
    end

    def rotate_left
      @angle -= 0.5
    end

    def rotate_right
      @angle += 0.5
    end
    
    def thrust
      self.velocity_x += Gosu::offset_x(@angle, 0.02)
      self.velocity_y += Gosu::offset_y(@angle, 0.02)
    end
  end
end