class SimControl::Controller
  attr_reader :current_simulation

  def initialize(hostname, simulation_description, scenario_description, results_directory, args = {})
    @hostname = hostname
    @simulation_description = simulation_description
    @scenario_description = scenario_description
    @results_directory = results_directory

    @hosts = args.delete(:hosts) || SimControl::Hosts.new
  end 

  def run
    instance_eval(@simulation_description)
    instance_eval(@scenario_description)

    @hosts.partition([],  @hostname).each do |scenarios_per_core|
      threads = []
      scenarios_per_core.each do |scenario|
        threads << Thread.new do
          current_simulation.simulate(scenario, seeds)
        end

        threads.each do |thread|
          thread.join
        end
      end
    end
  end

  def hosts(&hosts_block)
    @hosts.process &hosts_block
  end

  def simulate(klass, arguments)
    @current_simulation = klass.new arguments
  end

  class << self
    def execute(hostname, simulation_description, scenario_description, results_directory)
      controller = SimControl::Controller.new(hostname, simulation_description, scenario_description, results_directory)
      controller.run
    end
  end
end
