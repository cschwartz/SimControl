class SimControl::Controller
  def initialize(simulation_description, scenario_description, results_directory)
    @simulation_description = simulation_description
    @scenario_description = scenario_description
    @results_directory = results_directory
  end 

  def run
    instance_eval(@simulation_description)
  end

  class << self
    def execute(simulation_description, scenario_description, results_directory)
      controller = SimControl::Controller.new(simulation_description, scenario_description, results_directory)
      controller.run
    end
  end
end
