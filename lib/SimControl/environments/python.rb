module SimControl
  class PythonEnvironment < BaseEnvironment
    def initialize(script, args = {})
      @script = script
      @interpreter = args.delete(:interpreter)
      @virtualenv = args.delete(:virtualenv)
      raise "passing a virtualenv requires an interpreter" if @virtualenv and not @interpreter
    end

    def execute(scenario)
      args = scenario.map { |k, v| "--#{ k } #{ v }" }.join " "
      command = [interpreter, @script, args].reject(&:nil?).reject(&:empty?).join " "
      `#{ command }`
    end

    def interpreter
      if @virtualenv
        File.join(@virtualenv, "bin", @interpreter) 
      else 
        @interpreter
      end
    end
  end
end
