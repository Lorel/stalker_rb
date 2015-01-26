class Agent < Marsys::Agent

  def initialize(environment, square = nil)
    super
  end

  # def to_json(options = {})
  #   super
  # end

  def move
    super
  end

  def turn
    super
  end
end

class Idol < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :yellow
  end

  def move
    move_to run_away_square1
  end

  def run_away_square1
    vector = @environment.stalkers.map{ |stalker|
      [ self.square.x - stalker.square.x, self.square.y - stalker.square.y ]
    }.inject([0,0]){ |res,el|
      [res[0]+el[0],res[1]+el[1]]
    }.map{ |x|
      x.to_f / @environment.stalkers.count
    }

    radian = Math.atan2(vector[1],vector[0])

    @environment.empty_squares_around( self.square ).sort{ |s1,s2|
      (Math.atan2(s1.y - @square.y, s1.x - @square.x) - radian).abs <=> (Math.atan2(s2.y - @square.y, s2.x - @square.x) - radian).abs
    }.first
  end

  def run_away_square2
    vector = @environment.stalkers.map{ |stalker|
      [ self.square.x - stalker.square.x, self.square.y - stalker.square.y ]
    }.inject([0,0]){ |res,el|
      [res[0]+el[0],res[1]+el[1]]
    }.map{ |x|
      x.to_f / @environment.stalkers.count
    }

    radian = Math.atan2(vector[1],vector[0])

    @environment.empty_squares_around( self.square ).reject{|s| s == @oldsquare}.sort{ |s1,s2|
      (Math.atan2(s1.y - @square.y, s1.x - @square.x) - radian).abs <=> (Math.atan2(s2.y - @square.y, s2.x - @square.x) - radian).abs
    }.first
  end

  def run_away_square3(d=1)
    vector = @environment.stalkers.map{ |stalker|
      [ self.square.x - stalker.square.x, self.square.y - stalker.square.y ]
    }.inject([0,0]){ |res,el|
      [res[0]+el[0],res[1]+el[1]]
    }.map{ |x|
      x.to_f / @environment.stalkers.count
    }

    radian = Math.atan2(vector[1],vector[0])

    @environment.empty_squares_around( self.square ).reject{|s| !s.x.between?(d,@environment.size-1-d) || !s.y.between?(d,@environment.size-1-d)}.sort{ |s1,s2|
      (Math.atan2(s1.y - @square.y, s1.x - @square.x) - radian).abs <=> (Math.atan2(s2.y - @square.y, s2.x - @square.x) - radian).abs
    }.first
  end

end

class Stalker < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :red
  end

  def move
    unless (@environment.best_square @square).nil?
      move_to( @environment.best_square @square ) # unless (@environment.best_square @square).nil?
    end
  end
end

class Block < Marsys::Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :black
  end
end