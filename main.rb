require 'pry'
require 'gosu'
require_relative './lib/pig'
require_relative './lib/enemy'
require_relative './lib/bounding_box'
require_relative 'menu'
require_relative './lib/home'
require_relative 'grid'

class Game < Gosu::Window
  attr_reader :state
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 950)
    @state = :menu
    @summon_counter = 0
    @menu = Menu.new(self, 0, 0)
    @large_font = Gosu::Font.new(self, 'futura', 100)
    @small_font = Gosu::Font.new(self, 'futura', 40)

    @lanes = []

  end

  def draw
    if @state == :menu
      @menu.draw
    end

    if @state == :running
      @grid.draw
      @pig.draw
      @lanes.each { |enemy| enemy.draw }

    end

    if @state == :lost
      # t = Time.now + 10
      #   while Time.now < t
      @menu.lose_image.draw(650, 220, 0)
      @menu.draw_text(275, 0, "Sorry, I win...", @large_font, 0xffffffff)
      @menu.draw_text(300, 125, "Press Enter to play again!", @small_font, 0xffffffff)

    end
  end


  def update
    @lanes.each { |enemy| enemy.update }

    @summon_counter += 1
    summon_farmers

    pig_collided?
    player_won?
  end

  def player_won?
    if @grid.home.bounds.intersects?(@pig.bounds)
      @state = :menu
      reset
    end
  end

  def pig_collided?
    [@lanes].each do |lane|
      lane.each do |enemy|
       if enemy.bounds.intersects?(@pig.bounds)
         @state = :lost
       end
      end
    end
  end

  def summon_farmers
    if (@summon_counter % 180 == 0) || (@summon_counter % 60 == 0) || (@summon_counter % 40 == 0)
      @lanes << Enemy.new(self, 1000, 700, -6)
      @lanes << Enemy.new(self, 0, 650, 8)
      @lanes << Enemy.new(self, 1000, 600, -6)
      @lanes << Enemy.new(self, 0, 750, 8)
    # end

    # if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lanes << Enemy.new(self, 0, 350, 10)
    # end

    # if (@summon_counter % 120 == 0) || (@summon_counter % 80 == 0)
      @lanes << Enemy.new(self, 1000, 500, -7)
    # end

    # if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lanes << Enemy.new(self, 0, 450, 9)
    # end

    # if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lanes << Enemy.new(self, 1000, 300, -8)
    # end

    # if (@summon_counter % 40 == 0) || (@summon_counter % 80 == 0)
      @lanes << Enemy.new(self, 1000, 250, -12)
    # end

    # if (@summon_counter % 60 == 0) || (@summon_counter % 30 == 0)
      @lanes << Enemy.new(self, 0, 200, 14)
    # end

    # if (@summon_counter % 30 == 0) || (@summon_counter % 80 == 0)
      @lanes << Enemy.new(self, 0, 400, 11)
    end
  end

  def lose_screen
    @state = :lose
  end

  def reset
    @state = :menu
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 900)
    @summon_counter = 0
    @menu = Menu.new(self, 0, 0)
    @lanes = [ Enemy.new(self, 1000, 500, -5) ]
  end

  def button_down(id)
    if id == Gosu::KbUp
      unless @pig.y <= 0
        @pig.y -= @pig.pig_speed
      end
    end
    if id == Gosu::KbDown
      unless @pig.y >= (1000 - @pig.pig_image.height)
        @pig.y += @pig.pig_speed
      end
    end
    if id == Gosu::KbLeft
      unless @pig.x <= 0
        @pig.x -= @pig.pig_speed
      end
    end
    if id == Gosu::KbRight
      unless @pig.x >= (1000 - @pig.pig_image.width)
        @pig.x += @pig.pig_speed
      end
    end
    if id == Gosu::KbSpace
      @state = :running
    end


      if id == Gosu::KbReturn
      @state = :menu
      reset
      end

  end
end

Game.new.show
