require "spec_helper"

require "SimControl"

require "fakefs/spec_helpers"

describe SimControl::CLI do
  let(:cli) { SimControl::CLI.new }

  include FakeFS::SpecHelpers
  describe "#newScenario" do
    describe "with scenario name" do
      let(:scenario) { "scenario" }

      before(:each) do
        FileUtils.mkdir("scenarios")
        FileUtils.mkdir("results")
        FileUtils.touch("Controlfile")
        FileUtils.mkdir_p("templates/scenario")
        File.open("templates/scenario/scenario.rb", "w") {  |f| f.write(scenario) }
        cli.invoke :newScenario, ["myScenario"]
      end

      it "creates scenarios/myScenario.rb" do
        expect(File.open("scenarios/myScenario.rb", "r").read).to eq(scenario)
      end

      it "creates results/myScenario/" do
        expect(File.directory?("results/myScenario")).to be_true
      end
    end

    describe "without scenario name" do
      it "fails" do
        expect do
          cli.invoke :newScenario
        end.to raise_error(Thor::InvocationError, /with no arguments/)
      end
    end

    describe "without init having been run" do
      it "fails if no scenarios folder exists" do
        FileUtils.mkdir("results")
        FileUtils.touch("Controlfile")
        expect do
          cli.invoke :newScenario, ["myScenario"]
        end.to raise_error(Thor::Error, /scenarios missing/)
      end

      it "fails if no results folder exists" do
        FileUtils.mkdir("scenarios")
        FileUtils.touch("Controlfile")
        expect do
          cli.invoke :newScenario, ["myScenario"]
        end.to raise_error(Thor::Error, /results missing/)
      end

      it "fails if no Controlfile exists" do
        FileUtils.mkdir("scenarios")
        FileUtils.mkdir("results")
        expect do
          cli.invoke :newScenario, ["myScenario"]
        end.to raise_error(Thor::Error, /Controlfile missing/)
      end
    end
  end
end
