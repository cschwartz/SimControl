module SimControl
  class Controller
    attr_reader :current_simulation

    def initialize(hostname, simulation_description, scenario_description, results_directory, args = {})
      @hosts = args.delete(:hosts) || SimControl::Hosts.new

      @hostname = hostname
      @simulation_description = simulation_description
      @scenario_description = scenario_description
      @results_directory = results_directory

      @scenarios = []

      @meta_seed = 13
      @max_seed = 2**(32 - 1) - 1
    end 

    def run
      instance_eval(@simulation_description)
      instance_eval(@scenario_description)

      @hosts.partition(all_scenarios, @hostname).each do |scenarios_per_core|
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

    def repetitions(number_of_repetitions)
      @number_of_repetitions = number_of_repetitions
    end

    def hosts(&hosts_block)
      @hosts.process &hosts_block
    end

    def simulation(klass, script, arguments)
      @current_simulation = klass.new script, arguments
    end

    def seeds
      @rng = Random.new(@meta_seed)
      (1..@number_of_repetitions).map { @rng.rand(@max_seed) }
    end

    def simulate(scenario)
      @scenarios << scenario
    end

    def all_scenarios
      @scenarios
    end

    class << self
      def execute(hostname, simulation_description, scenario_description, results_directory)
        controller = SimControl::Controller.new(hostname, simulation_description, scenario_description, results_directory)
        controller.run
      end
    end
  end
end
