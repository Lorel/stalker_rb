class Environment < Marsys::Environment
  def turn
    dijkstra
    super
  end

  def squares_around square
    super.shuffle #.select{|s| (s.x == square.x) || (s.y == square.y) }
  end

  def dijkstra
    reset_dijkstra_value
    @idols.first.square.from_idol = 0
    set_dijkstra_value_it @idols.first.square
  end

  def set_dijkstra_value_it square
    undone = []
    (square.x).downto(0).to_a.concat(((square.x+1)..(@size-1)).to_a).each do |x|
      (square.y).downto(0).to_a.concat(((square.y+1)..(@size-1)).to_a).each do |y|
        unless ( (x == square.x) && (y == square.y) ) ||
            ( @grid[x][y].content.is_a? Block )
          if squares_around(@grid[x][y]).reject{|s| s.from_idol.nil?}.empty?
            undone << @grid[x][y]
          else
            @grid[x][y].from_idol = squares_around(@grid[x][y]).reject{|s| s.from_idol.nil?}.map{|s| s.from_idol}.min + 1
          end
        end
        # display_dijkstra
      end
    end
    while (!undone.empty?) do
      undone.each{ |sq|
        unless squares_around(sq).reject{|s| s.from_idol.nil?}.empty?
          sq.from_idol = squares_around(sq).reject{ |s| s.from_idol.nil? }.map{ |s| s.from_idol }.min + 1
        end
      }
      count = undone.count
      undone.select!{ |s| s.from_idol.nil? }
      undone = [] if undone.count == count
      # display_dijkstra
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
    squares_around(square).reject{ |s| s.from_idol.nil? }.shuffle.min
  end

  def display_dijkstra
    puts "__" * @size + "\n" + @grid.inject(""){ |res,line| res + line.inject(""){ |res,square| res + ( !square.from_idol.nil? ? ( (square.from_idol < 10) ? square.from_idol.to_s : "x" ) : "-" ) + " " } + "\n" } + "__" * @size + "\n"
  end

  def to_json(options = {})
    json = {
      grid:                 @grid.map{|line| line.map{ |square|
                              square.content ? square.content.class.to_s.downcase : nil
                            }},
      iteration:            @iteration,
      stop_condition:       options[:stop_condition]
    }
    json.to_json
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