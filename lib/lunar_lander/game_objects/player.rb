module LunarLander
  class Player < Chingu::GameObject
    trait :velocity
    trait :bounding_box
    
    attr_accessor :fuel
    
    def setup
      @x = $window.width / 2
      @y = $window.height / 2
      self.image = Gosu::Image["player.png"]
      @engine_sound = Gosu::Sound["fierce_wind.wav"].play(1, 1, true)
      @engine_sound.pause
      self.acceleration_y = 0.01
      self.velocity_y = 1
      @particle_animation = Chingu::Animation.new(:file => "particle.png", :size => [32, 32])
      @fuel = 100.0
    end

    def rotate_left
      @angle -= 0.5
      
      Chingu::Particle.create( 
        :x => @x + Gosu::offset_x(@angle + 60, 20 * @factor),
        :y => @y + Gosu::offset_y(@angle + 60, 20 * @factor),
        :animation => @particle_animation,
        :scale_rate => -0.03, 
        :fade_rate => -35, 
        :rotation_rate => +1,
        :mode => :default,
        :factor => @factor / 2
      )
      Chingu::Particle.each { |particle| 
        particle.x -= Gosu::offset_x(@angle-90, 2 * @factor)
        particle.y -= Gosu::offset_y(@angle-90, 2 * @factor)
      }
    end

    def rotate_right
      @angle += 0.5
      
      Chingu::Particle.create( 
        :x => @x + Gosu::offset_x(@angle - 60, 20 * @factor), 
        :y => @y + Gosu::offset_y(@angle - 60, 20 * @factor), 
        :animation => @particle_animation,
        :scale_rate => -0.03, 
        :fade_rate => -35, 
        :rotation_rate => +1,
        :mode => :default,
        :factor => @factor / 2
      )
      Chingu::Particle.each { |particle| 
        particle.x -= Gosu::offset_x(@angle+90, 2 * @factor)
        particle.y -= Gosu::offset_y(@angle+90, 2 * @factor)
      }
    end
    
    def thrust
      if @fuel > 0
        self.velocity_x += Gosu::offset_x(@angle, 0.05)
        self.velocity_y += Gosu::offset_y(@angle, 0.05)

        Chingu::Particle.create( 
          :x => @x - Gosu::offset_x(@angle, 20 * @factor), 
          :y => @y - Gosu::offset_y(@angle, 20 * @factor), 
          :animation => @particle_animation,
          :scale_rate => -0.03, 
          :fade_rate => -35, 
          :rotation_rate => +1,
          :mode => :default,
          :factor => @factor
        )
        
        Chingu::Particle.each { |particle| 
          particle.x -= Gosu::offset_x(@angle, 10 * @factor + rand(4))
          particle.y -= Gosu::offset_y(@angle, 10 * @factor + rand(4))
        }
        @engine_sound.resume unless @engine_sound.playing?
      
        @fuel -= 0.5
      end
    end
    
    def stop_engine
      @engine_sound.pause
    end
    
    def stop
      self.velocity_x = 0
      self.velocity_y = 0
    end
    
    def die
      @engine_sound.stop
      Gosu::Sound["explosion.wav"].play
    end
    
    def should_die?
      velocity_x > 0.5 or velocity_y > 0.4 or angle.abs > 5
    end
    
    def update
      super
      @engine_sound.stop if @fuel == 0
    end
  end
end