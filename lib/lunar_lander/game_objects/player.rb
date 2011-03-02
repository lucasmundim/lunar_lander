module LunarLander
  class Player < Chingu::GameObject
    trait :velocity
    trait :bounding_box
    
    def initialize(options={})
      super(options.merge(:image => Gosu::Image["player.png"]))
    end
    
    def setup
      @engine_sound = Gosu::Sound["fierce_wind.wav"].play(1,1,true)
      @engine_sound.pause
      self.acceleration_y = 0.01
      self.velocity_y = 1
      @particle_animation = Chingu::Animation.new(:file => "particle.png", :size => [32,32])
    end

    def rotate_left
      @angle -= 0.5
      
      Chingu::Particle.create( 
        :x => @x + Gosu::offset_x(@angle + 60, 20),
        :y => @y + Gosu::offset_y(@angle + 60, 20),
        :animation => @particle_animation,
        :scale_rate => -0.03, 
        :fade_rate => -35, 
        :rotation_rate => +1,
        :mode => :default,
        :factor => 0.5
      )
      Chingu::Particle.each { |particle| 
        particle.y -= Gosu::offset_y(@angle-90, 2)
        particle.x -= Gosu::offset_x(@angle-90, 2)
      }
    end

    def rotate_right
      @angle += 0.5
      
      Chingu::Particle.create( 
        :x => @x + Gosu::offset_x(@angle - 60, 20), 
        :y => @y + Gosu::offset_y(@angle - 60, 20), 
        :animation => @particle_animation,
        :scale_rate => -0.03, 
        :fade_rate => -35, 
        :rotation_rate => +1,
        :mode => :default,
        :factor => 0.5
      )
      Chingu::Particle.each { |particle| 
        particle.y -= Gosu::offset_y(@angle+90, 2)
        particle.x -= Gosu::offset_x(@angle+90, 2)
      }
    end
    
    def thrust
      self.velocity_x += Gosu::offset_x(@angle, 0.05)
      self.velocity_y += Gosu::offset_y(@angle, 0.05)

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
      @engine_sound.resume unless @engine_sound.playing?
    end
    
    def stop_engine
      @engine_sound.pause
    end
    
    def stop
      self.velocity_x = 0
      self.velocity_y = 0
    end
    
    def die
      Gosu::Sound["explosion.wav"].play
    end
    
    def update
      super
      @x %= $window.width
      #@y %= 480
    end
  end
end