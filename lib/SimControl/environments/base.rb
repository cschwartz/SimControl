module SimControl
  class BaseEnvironment
    def simulate(scenario, seeds)
      seeds.each do |seed|
        execute(scenario.args({seed: seed}))
      end
    end
  end
end
