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

    def self.source_root
      File.join(SimControl.root, 'templates')
    end
  end
end

