class Core < Marsys::Core
  def initialize(options={})
    @agents = [:idol, :stalker, :block]
    @environment = Environment.new(@agents,options)
    super(options)
  end

  def display
    @environment.display
    puts @iteration
    # @environment.display_dijkstra
  end

  def to_json(options = {})
    super(options.merge({ stop_condition: stop_condition? }))
  end

  def stop_condition?
    !@environment.squares_around_with_stalker(@environment.idols.first.square).empty?
  end
end