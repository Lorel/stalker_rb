class Environment < Marsys::Environment
  def turn
    dijkstra
    super
  end

  def squares_around square
    super.select{|s| (s.x == square.x) || (s.y == square.y) }
  end

  def dijkstra
    reset_dijkstra_value
    @idols.first.square.from_idol = 0
    set_dijkstra_value_it @idols.first.square
  end

  def set_dijkstra_value_it square
    (square.x).downto(0).to_a.concat(((square.x+1)..(@size-1)).to_a).each do |x|
      (square.y).downto(0).to_a.concat(((square.y+1)..(@size-1)).to_a).each do |y|
        unless ( (x == square.x) && (y == square.y) ) ||
            ( @grid[x][y].content.is_a? Block ) ||
            squares_around(@grid[x][y]).reject{|s| s.from_idol.nil?}.empty?
          @grid[x][y].from_idol = squares_around(@grid[x][y]).reject{|s| s.from_idol.nil?}.map{|s| s.from_idol}.min + 1
        end
        # display_dijkstra
        # sleep 0.01
      end
    end
  end

  def set_dijkstra_value_rec square
    squares_around(square).reject{ |s|
      ( (s.content.is_a? Block) ||
        (!s.from_idol.nil? && (s.from_idol <= square.from_idol + 1) )
      )
    }.each{ |s|
      s.from_idol = square.from_idol + 1
      # display_dijkstra
      # sleep(0.1)
    }.each{ |s|
      set_dijkstra_value_rec s
    }
  end

  def reset_dijkstra_value
    @grid.each do |line|
      line.each do |square|
        square.from_idol = nil
      end
    end
  end

  def best_square square
    squares_around(square).reject{ |s| s.from_idol.nil? }.min
  end

  def display_dijkstra
    puts "__" * @size + "\n" + @grid.inject(""){ |res,line| res + line.inject(""){ |res,square| res + ( !square.from_idol.nil? ? ( (square.from_idol < 10) ? square.from_idol.to_s : "x" ) : "-" ) + " " } + "\n" } + "__" * @size + "\n"
  end

  Marsys::Environment::Square.class_eval do
    include Comparable
    attr_accessor :from_idol

    def <=> other
      return super if (self.from_idol.nil? && other.from_idol.nil?)
      self.from_idol <=> other.from_idol
    end
  end
end