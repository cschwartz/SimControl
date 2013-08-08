module SimControl
  class BaseEnvironment
    def simulate(args, seeds)
      p args
      seeds.each do |seed|
        execute(args.merge({seed: seed}))
      end
    end
  end
end
