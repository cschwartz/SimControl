require "SimControl/version"
require "SimControl/cli"
require "SimControl/controller"
require "SimControl/hosts"
require "SimControl/scenario"
require "SimControl/environments/base"
require "SimControl/environments/python"

module SimControl
  def self.root
    File.expand_path('../..',__FILE__)
  end
end
