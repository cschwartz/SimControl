module SimControl
  class BaseEnvironment
    def initialize(results_path)
      @results_path = results_path
    end

    def simulate(scenario, seeds)
      seeds.each do |seed|
        execute(scenario.args({seed: seed, results: @results_path}))
      end
    end
  end
end
