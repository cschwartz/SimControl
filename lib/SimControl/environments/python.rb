module SimControl
  class PythonEnvironment
    def initialize(script, args = {})
      @script = script
      @interpreter = args.delete(:interpreter)
      @virtualenv = args.delete(:virtualenv)
      raise "passing a virtualenv requires an interpreter" if @virtualenv and not @interpreter
    end

    def execute(scenario)
      @interpreter = File.join(@virtualenv, "bin", @interpreter) if @virtualenv
      args = scenario.map { |k, v| "--#{ k } #{ v }" }.join " "
      command = [@interpreter, @script, args].reject(&:nil?).reject(&:empty?).join " "
      `#{ command }`
    end

  end
end
