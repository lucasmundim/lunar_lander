module LunarLander
  class Player < Chingu::GameObject
    trait :velocity
    
    def initialize(options={})
      super(options.merge(:image => Gosu::Image["player.png"]))
    end
    
    def setup
      self.acceleration_y = 0.01
      self.velocity_y = 1
      
      @particle_animation = Chingu::Animation.new(:file => "particle.png", :size => [32,32])
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

      Chingu::Particle.create( 
        :x => @x - Gosu::offset_x(@angle, 20), 
        :y => @y - Gosu::offset_y(@angle, 20), 
        :animation => @particle_animation,
        :scale_rate => -0.03, 
        :fade_rate => -35, 
        :rotation_rate => +1,
        :mode => :default
      )
      Chingu::Particle.each { |particle| 
        particle.y -= Gosu::offset_y(@angle, 10 + rand(4))
        particle.x -= Gosu::offset_x(@angle, 10 + rand(4))
      }
    end
  end
end