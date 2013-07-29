require "spec_helper"

require "SimControl"

require "fakefs/spec_helpers"

describe SimControl::CLI do
  let(:cli) { SimControl::CLI.new }

  include FakeFS::SpecHelpers
  describe "#init creates the control structure" do
    let(:controlfile) { "Content" }
    before(:each) do
      FileUtils.mkdir_p("templates/scaffolding")
      File.open("templates/scaffolding/Controlfile", "w") {  |f| f.write(controlfile) }
    end

    before(:each) do
      cli.invoke :init
    end

    it "creates the scenarios folder" do
      expect(File.directory?("scenarios")).to be(true)
    end

    it "creates the results folder" do
      expect(File.directory?("results")).to be(true)
    end

    it "creates the Controlfile with appropriate content" do
      expect(File.open("Controlfile", "r").read).to eq(controlfile)
    end
  end
end
