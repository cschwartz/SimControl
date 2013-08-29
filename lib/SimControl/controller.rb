module SimControl
  class Controller
    attr_reader :current_simulation

    def initialize(hostname, simulation_description, scenario_description, results_directory, args = {})
      @hosts = args.delete(:hosts) || SimControl::Hosts.new
      @scenario_klass = args.delete(:scenario_klass) || SimControl::Scenario

      @hostname = hostname
      @simulation_description = simulation_description
      @scenario_description = scenario_description
      @results_directory = results_directory

      @scenarios = []

      @meta_seed = 13
      @max_seed = 2**(32 - 1) - 1
    end 

    def create_scenario(*args)
      @scenario_klass.new(*args)
    end

    def run
      instance_eval(@simulation_description)
      instance_eval(@scenario_description)

      host_scenarios = @hosts.partition(all_scenarios, @hostname)

      threads = []
      host_scenarios.each do |scenarios_per_core|
        threads << Thread.new do
          scenarios_per_core.each do |scenario|
            current_simulation.simulate(scenario, seeds)
          end
        end
      end
      threads.each do |thread|
        thread.join
      end
    end

    def repetitions(number_of_repetitions)
      @number_of_repetitions = number_of_repetitions
    end

    def hosts(&hosts_block)
      @hosts.process &hosts_block
    end

    def simulation(klass, script, arguments)
      @current_simulation = klass.new script, @results_directory, arguments
    end

    def seeds
      @rng = Random.new(@meta_seed)
      (1..@number_of_repetitions).map { @rng.rand(@max_seed) }
    end

    def simulate(*scenario)
      @scenarios << (create_scenario *scenario)
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
