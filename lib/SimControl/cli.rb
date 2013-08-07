require "thor"
require "socket"

module SimControl
  class CLI < Thor
    include Thor::Actions

    desc "init", "creates scaffolding for SimControl in this directory"
    def init
      base_dir = Dir.pwd
      destination_root= base_dir
      empty_directory "scenarios"
      empty_directory "results"
      copy_file "scaffolding/Controlfile", "Controlfile"
    end

    desc "newScenario SCENARIO", "creates a new scenario of name SCENARIO"
    def newScenario(name)
      SimControl::CLI.init_generated_files_exist?

      copy_file "scenario/scenario.rb", File.join("scenarios", "#{ name }.rb")
      empty_directory File.join("results", name)
    end

    desc "simulate SCENARIO", "simulates a subsets of SCENARIO on the current HOSTNAME"
    def simulate(scenario)
      SimControl::CLI.init_generated_files_exist?
      SimControl::CLI.scenario_files_exist?(scenario)

      SimControl::Controller.execute(hostname, 
                                    simulation_description,
                                    scenario_description(scenario),
                                    results_directory(scenario))
    end

    no_commands {
      def hostname
        Socket.gethostname
      end

      def simulation_description
        File.open(control_file_name).read
      end

      def scenario_description(scenario)
        File.open(scenario_file_name(scenario)).read
      end

      def results_directory(scenario)
        File.join("results", scenario)
      end

      def control_file_name
        File.join(Dir.pwd, "Controlfile")
      end

      def scenario_file_name(scenario)
        File.join(Dir.pwd, "scenarios",  "#{ scenario }.rb")
      end

      def self.scenario_files_exist?(scenario)
        raise Thor::Error.new "#{ CLI::scenario_path(scenario) } missing, run newScenario # scenario }" unless File.exists?(CLI::scenario_path(scenario))
        raise Thor::Error.new "#{ CLI::results_path(scenario) } missing, run newScenario # scenario }" unless File.directory?(CLI::results_path(scenario))
      end

      def self.results_path(scenario_name)
        results_path = File.join("results", scenario_name)
      end

      def self.scenario_path(scenario_name)
        scenario_path = File.join("scenarios", "#{scenario_name}.rb")
      end

      def self.init_generated_files_exist?
        raise Thor::Error.new "scenarios missing, run init" unless File.directory?("scenarios")
        raise Thor::Error.new "results missing, run init" unless File.directory?("results")
        raise Thor::Error.new "Controlfile missing, run init" unless File.exists?("Controlfile")
      end

      def self.source_root
        File.join(SimControl.root, 'templates')
      end
  }
  end
end

