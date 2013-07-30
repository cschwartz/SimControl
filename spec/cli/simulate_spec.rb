require "spec_helper"
require "simcontrol"

require "fakefs/spec_helpers"

describe SimControl::CLI do
  include FakeFS::SpecHelpers
  describe "simulate" do
    before(:each) do
      scenario = "hosts {}"
      FileUtils.mkdir("scenarios")
      FileUtils.mkdir("results")
      FileUtils.touch("Controlfile")
      FileUtils.touch("scenarios/myScenario.rb")
      FileUtils.mkdir_p("results/myScenario")
    end

    it  "calls SimControl::Controller.execute()" do
      scenario_description = "scenario"
      simulation_description = "simulation"
      results_path = File.join("results", "myScenario")
      File.open("scenarios/myScenario.rb", "w") {  |f| f.write(scenario_description) }
      File.open("Controlfile", "w") {  |f| f.write(simulation_description) }
      SimControl::Controller.should_receive(:execute).with(simulation_description, scenario_description, results_path)
      SimControl::CLI.new.invoke :simulate, ["myScenario"]
    end

    it "fails if no results directory exists" do
      FileUtils.rm_rf("results")
      expect do
        SimControl::CLI.new.invoke :simulate, ["myScenario"]
      end.to raise_error(Thor::Error, /results missing/)
    end

    it "fails if no results directory exists for the scenario" do
      FileUtils.rm_rf("results/myScenario")
      expect do
        SimControl::CLI.new.invoke :simulate, ["myScenario"]
      end.to raise_error(Thor::Error, /results\/myScenario missing/)
    end

    it "fails if no scenarios directory exists" do
      FileUtils.rm_rf("scenarios")
      expect do
        SimControl::CLI.new.invoke :simulate, ["myScenario"]
      end.to raise_error(Thor::Error, /scenarios missing/)
    end

    it "fails if the scenario description does not exist" do
      FileUtils.rm("scenarios/myScenario.rb")
      expect do
        SimControl::CLI.new.invoke :simulate, ["myScenario"]
      end.to raise_error(Thor::Error, /scenarios\/myScenario.rb missing/)
    end

    it "fails if the Controlfile does not exist" do
      FileUtils.rm("Controlfile")
      expect do
        SimControl::CLI.new.invoke :simulate, ["myScenario"]
      end.to raise_error(Thor::Error, /Controlfile missing/)
    end
  end
end
