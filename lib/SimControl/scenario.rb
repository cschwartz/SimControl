module SimControl
  class Scenario
    def initialize(*args)
      options = Hash.try_convert(args.last)
      if options
        args.pop
      end
      @commands = args
      @options = options || {}
    end

    def options(other_options = {})
      other_options.merge(@options).map { |k, v| "--#{ k } #{ v }" }.join " "
    end

    def commands
      @commands.join(" ").strip
    end

    def args(other_options = {})
      [options(other_options), commands].join(" ").strip
    end
  end
end
