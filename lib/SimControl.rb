require "SimControl/version"
require "SimControl/cli"

module SimControl
  def self.root
    File.expand_path('../..',__FILE__)
  end
end
