module SimControl
  class Scenario
    def initialize(*args)
      options = Hash.try_convert(args.last)
      if options
        args.pop
      end
      @commands = args
      @options = options
    end

    def options
      @options.map { |k, v| "--#{ k } #{ v }" }.join " "
    end

    def commands
      @commands.join(" ").strip
    end

    def args
      [commands, options].join " "
    end
  end
end
