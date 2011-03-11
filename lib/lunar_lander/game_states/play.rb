# -*- coding: utf-8 -*-
module LunarLander
  
  class Play < Chingu::GameState
    trait :timer
    
    def setup
      self.input = { :p => LunarLander::Pause, :holding_z => :zoom_in, :holding_x => :zoom_out, :c => :cinema_zoom }
      
      @player = Player.new
      @player.input = {:holding_left => :rotate_left, :holding_right => :rotate_right, :holding_up => :thrust, :released_up => :stop_engine}
      
      @surface = Chingu::Rect.new(0, $window.height-50, 800, 50)
      @background = Gosu::Image["earth.png"]
      
      setup_hud
      @factor = 1
    end
    
    def cinema_zoom
      during(3000) do
        zoom_in
      end
    end
    
    def zoom_in
      @factor += 0.001
      zoom_by_factor
    end
    
    def zoom_out
      @factor -= 0.001
      zoom_by_factor
    end
    
    def zoom_by_factor
      game_objects.each do |game_object|
        next if game_object.kind_of? Chingu::Text
        game_object.factor = @factor
      end
      @player.factor = @factor
      Chingu::Particle.all.each do |p| p.factor = @factor end
    end
    
    def destroy_particles
      game_objects.destroy_if do |object| 
        if object.kind_of? Chingu::Particle
          object.outside_window? || object.color.alpha == 0
        end
      end
    end
    
    def setup_hud
      @velocity_x_text = Chingu::Text.create("Velocidade Lateral: 0", :x => 10, :y => 10, :zorder => 55, :size=>20)
      @velocity_y_text = Chingu::Text.create("Velocidade Vertical: 0", :x => 10, :y => 30, :zorder => 55, :size=>20)
      @angle_text = Chingu::Text.create("Ângulo: 0", :x => 10, :y => 50, :zorder => 55, :size=>20)
      @fuel_text = Chingu::Text.create("Combustível: #{@player.fuel}", :x => 10, :y => 70, :zorder => 55, :size=>20)
    end
    
    def update_hud
      if @player
         update_text_if_needed(@velocity_x_text, "Velocidade Lateral: #{(@player.velocity_x * 10).ceil.abs}")
         update_text_if_needed(@velocity_y_text, "Velocidade Vertical: #{(@player.velocity_y * 10).ceil * -1}")
         update_text_if_needed(@angle_text, "Ângulo: #{@player.angle}")
         update_text_if_needed(@fuel_text, "Combustível: #{@player.fuel.ceil}")
      end
    end
    
    def update_text_if_needed(text_instance, text)
      text_instance.text = text unless text_instance.text == text
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
    
    
    def update
      super
      @player.update_trait
      @player.update
      destroy_particles
      test_colision
      update_hud
    end
        
    def draw
      super
      @background.draw(($window.width / 2) - (@background.width * 0.5)/2, ($window.height / 2) - (@background.height * 0.5) / 2, 0, 0.5, 0.5)
      
        @player.draw
    end
  end
end
