module LunarLander
  class Gameover < Chingu::GameState
    
    def initialize(options = {})
      super
      
      @white = Gosu::Color.new(255,255,255,255)
      @color = Gosu::Color.new(200,0,0,0)
      @font = Gosu::Font[35]
      @text = ["Perdeu playboy!","Pressione 'n' para tentar novamente."]
      
      self.input = { :n => :new_game }
    end
  
    def new_game
      switch_game_state LunarLander::Play
    end
    
    def draw
      previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
      $window.draw_quad(  0,0,@color,
                          $window.width,0,@color,
                          $window.width,$window.height,@color,
                          0,$window.height,@color, Chingu::DEBUG_ZORDER)
      
      @text.each_with_index do |text, index|                    
        @font.draw(text, ($window.width/2 - @font.text_width(text)/2), $window.height/2 - (@font.height - (index * @font.height)), Chingu::DEBUG_ZORDER + 1)
      end
    end
  
  end
end