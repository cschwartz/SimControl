class SimControl::Controller
  attr_reader :current_simulation

  def initialize(simulation_description, scenario_description, results_directory, args = {})
    @simulation_description = simulation_description
    @scenario_description = scenario_description
    @results_directory = results_directory

    @hosts = args.delete(:hosts) || SimControl::Hosts.new
  end 

  def run
    instance_eval(@simulation_description)
    instance_eval(@scenario_description)

    @hosts.partition([],  "a-hostname").each do |scenarios_per_core|
      scenarios_per_core.each do |scenario|
        current_simulation.simulate(scenario)
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
    def execute(simulation_description, scenario_description, results_directory)
      controller = SimControl::Controller.new(simulation_description, scenario_description, results_directory)
      controller.run
    end
  end
end
