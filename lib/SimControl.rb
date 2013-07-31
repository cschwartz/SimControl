require "SimControl/version"
require "SimControl/cli"
require "SimControl/controller"
require "SimControl/hosts"

module SimControl
  def self.root
    File.expand_path('../..',__FILE__)
  end
end
