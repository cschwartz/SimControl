require "spec_helper"

require "SimControl"

#require "fakefs"
require "fakefs/spec_helpers"

describe SimControl::CLI do
  include FakeFS::SpecHelpers
  let(:directory_name) { "/directory/name" }

  describe "creates the control structure" do
    it "creates the scenarios folder" do
      SimControl::CLI.new.invoke :init
    end
  end
end
