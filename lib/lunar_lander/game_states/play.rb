# -*- coding: utf-8 -*-
module LunarLander
  
  class Play < Chingu::GameState
    trait :timer
    
    def setup
      self.input = { :p => LunarLander::Pause, :holding_z => :zoom_in, :holding_x => :zoom_out, :c => :cinema_zoom, :holding_d => :camera_right, :holding_a => :camera_left }
      
      @player = Player.new
      @player.input = {:holding_left => :rotate_left, :holding_right => :rotate_right, :holding_up => :thrust, :released_up => :stop_engine}
      
      @surface = Chingu::Rect.new(0, $window.height-50, 800, 50)
      @background = Gosu::Image["earth.png"]
      
      @moon = Gosu::Image["moon.png"]
      @parallax = Chingu::Parallax.create(:x => 0, :y => $window.height - @moon.height, :rotation_center => :top_left, :zorder => 1)
      @parallax << { :image => @moon, :repeat_x => true, :repeat_y => false}
      setup_hud
      @factor = 1
    end
    
    def camera_left
      @parallax.camera_x -= 2
    end

    def camera_right
      @parallax.camera_x += 2
    end
    
    def adjust_parallax_viewport	
      @parallax.camera_x += @player.velocity_x if @player.x > $window.width * 0.8 or @player.x < $window.width * 0.2
      @parallax.camera_y += @player.velocity_y if @player.y < $window.height * 0.2 or (@player.y > $window.height * 0.2 and @parallax.camera_y < -($window.height - @moon.height)) 
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
        if game_object.kind_of? Chingu::Parallax
          game_object.layers.each do |p| p.factor = @factor end
          game_object.y = $window.height - (@moon.height * game_object.factor)
        end
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
    
    def restrict_player_movement
      if @player.x > $window.width * 0.8
        @player.x = $window.width * 0.8
      elsif @player.x < $window.width * 0.2
        @player.x = $window.width * 0.2
      end
      if @player.y > $window.height * 0.2 and @parallax.camera_y < -($window.height - @moon.height)
        @player.y = $window.height * 0.2 
      elsif @player.y < $window.height * 0.2
        @player.y = $window.height * 0.2
      end
    end
    
    def update
      super
      @player.update_trait
      @player.update
      destroy_particles
      test_colision
      update_hud
      adjust_parallax_viewport
      restrict_player_movement
    end
        
    def draw
      super
      @background.draw(($window.width / 2) - (@background.width * 0.5)/2, ($window.height / 2) - (@background.height * 0.5) / 2, 0, 0.5, 0.5)

      offset_x = 0
      if @player.x > $window.width * 0.8
        offset_x = -(@player.x - $window.width * 0.8)
      elsif @player.x < $window.width * 0.2
        offset_x = -(@player.x - $window.width * 0.2)
      end
      
      offset_y = 0
      if @player.y > $window.height * 0.2 and @parallax.camera_y < -($window.height - @moon.height)
        offset_y = -(@player.y - $window.height * 0.2)
      elsif @player.y < $window.height * 0.2
        offset_y = -(@player.y - $window.height * 0.2)
      end
      
      $window.translate(offset_x, offset_y) do
        @player.draw
      end
    end
  end
end
