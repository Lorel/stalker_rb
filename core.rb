require 'marsys'
require 'pp'

load "agent.rb"
load "environment.rb"

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

  def stop_condition?
    !@environment.squares_around_with_stalker(@environment.idols.first.square).empty?
  end
end

test = Core.new
test.display
puts test.to_json