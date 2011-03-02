# -*- coding: utf-8 -*-
module LunarLander
  class Play < Chingu::GameState
    def setup
      self.input = { :p => LunarLander::Pause }
      
      @player = Player.create({ :x => $window.width/2, :y => $window.height/2})
      @player.input = {:holding_left => :rotate_left, :holding_right => :rotate_right, :holding_up => :thrust, :released_up => :stop_engine}
      
      @background = Gosu::Image["moon.png"]
      @surface = Chingu::Rect.new(0, $window.height-50, 800, 50)
      
      setup_hud
    end
    
    def update
      super
      
      game_objects.destroy_if { |object| 
        if object.kind_of? Chingu::Particle
          object.outside_window? || object.color.alpha == 0
        end
      }
      
      test_colision
      
       update_hud
    end
    
    def setup_hud
      @velocity_x_text = Chingu::Text.create("Velocidade Lateral: 0", :x => 10, :y => 10, :zorder => 55, :size=>20)
      @velocity_y_text = Chingu::Text.create("Velocidade Vertical: 0", :x => 10, :y => 30, :zorder => 55, :size=>20)
      @angle_text = Chingu::Text.create("Ângulo: 0", :x => 10, :y => 50, :zorder => 55, :size=>20)
      @fuel_text = Chingu::Text.create("Combustível: #{@player.fuel}", :x => 10, :y => 70, :zorder => 55, :size=>20)
    end
    
    def update_hud
      if @player
         @velocity_x_text.text = "Velocidade Lateral: #{(@player.velocity_x * 10).ceil.abs}"
         @velocity_y_text.text = "Velocidade Vertical: #{(@player.velocity_y * 10).ceil * -1}"
         @angle_text.text = "Ângulo: #{@player.angle}"
         @fuel_text.text = "Combustível: #{@player.fuel.ceil}"
      end
    end
    
    def test_colision
      if @player.bounding_box.collide_rect?(@surface)
        if @player.should_die?
          @player.die
          switch_game_state LunarLander::Gameover
        else
          switch_game_state LunarLander::Leveldone  
        end
        @player.stop
      end
    end
    
    
    def draw
      super
      @background.draw(0,0,0)
      
    end
  end
end
