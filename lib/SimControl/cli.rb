require "thor"

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
      raise Thor::Error.new "scenarios missing, run init" unless File.directory?("scenarios")
      raise Thor::Error.new "results missing, run init" unless File.directory?("results")
      raise Thor::Error.new "Controlfile missing, run init" unless File.exists?("Controlfile")

      copy_file "scenario/scenario.rb", File.join("scenarios", "#{ name }.rb")
      empty_directory File.join("results", name)
    end

    def self.source_root
      File.join(SimControl.root, 'templates')
    end
  end
end

