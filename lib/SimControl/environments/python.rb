require "open3"

module SimControl
  class PythonEnvironment < BaseEnvironment
    def initialize(script, results_directory, args = {})
      super(results_directory)
      @script = script
      @interpreter = args.delete(:interpreter)
      @virtualenv = args.delete(:virtualenv)
      raise "passing a virtualenv requires an interpreter" if @virtualenv and not @interpreter
    end

    def script
      @script
    end

    def execute(scenario)
      stdin, stout, stderr, thread = Open3.popen3 command(scenario), chdir: basedir
      thread.join
    end

    def basedir
      File.dirname @script
    end

    def command(scenario)
      [interpreter, script, scenario].reject(&:nil?).reject(&:empty?).join " "
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
