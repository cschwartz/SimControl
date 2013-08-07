module SimControl
  class BaseEnvironment
    def simulate(args, seeds)
      seeds.each do |seed|
        execute(args.merge({seed: seed}))
      end
    end
  end
end
