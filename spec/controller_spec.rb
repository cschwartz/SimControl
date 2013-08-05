require "spec_helper"

describe SimControl::Controller do
  describe "#execute" do
    it "creates a new controller instance and runs it with the called arguments" do
      hostname = "a-hostname"
      simulation_description = double("simulation_description")
      scenario_description = double("scenario_description")
      results_directory = double("results_directory")
      instance = double(SimControl::Controller)
      SimControl::Controller.should_receive(:new).with(hostname, simulation_description, scenario_description, results_directory).and_return(instance)
      instance.should_receive(:run)
      SimControl::Controller.execute(hostname, simulation_description, scenario_description, results_directory)
    end

    it "calls methods called from the simulation description on the controller instance" do
      simulation_description = <<Controlfile
  hosts
Controlfile
      instance = SimControl::Controller.new("", simulation_description, "", "")
      instance.should_receive(:hosts)
      instance.run
    end

    it "calls methods called from the scenario description on the controller instance" do
      scenario_description = <<scenario
  simulate
scenario
      instance = SimControl::Controller.new("", "",  scenario_description, "")
      instance.should_receive(:simulate)
      instance.run
    end
  end 

  describe "#hosts" do
    it "yields the given block" do
      proc = Proc.new do

      end
      hosts = double("Hosts")
      hosts.should_receive(:process).with(&proc)
      instance = SimControl::Controller.new("", "", "", "", hosts: hosts)
      instance.hosts &proc
    end
  end

  describe "#simulation" do
    it "creates a new instance of the given class and passes the hash" do
      hash = double("Hash")
      instance = SimControl::Controller.new("", "", "", "")
      Klass = double("Klass")
      Klass.should_receive(:new).with(hash)
      instance.simulate Klass, hash
    end

    it "allows for the instance to be obtained as #current_simulation" do
      simulation_instance = double("simulation_instance")
      instance = SimControl::Controller.new("", "", "", "")
      Klass = double("Klass")
      Klass.stub(:new) { simulation_instance }
      instance.simulate Klass, {}
      expect(instance.current_simulation).to be(simulation_instance)
    end
  end

  describe "#run" do
    let(:hostname) { "a-hostname" }
    let(:scenario_a) { {setting: "a-value"} }
    let(:scenario_b) { {setting: "another-value"} }
    let(:seeds) { [1, 2] }
    let(:simulation_instance) { double("simulation_instance") }
    let(:hosts) { double("Hosts") }
      subject { SimControl::Controller.new(hostname, "", "", "", hosts: hosts).tap do |c|
        c.stub(:seeds).and_return(seeds)
        c.stub(:current_simulation).and_return(simulation_instance)
      end
    }

    it "calls execute on the simulation instance for each parameter combination for the given host" do
      per_host_scenarios = [[scenario_a, scenario_b]]

      hosts.should_receive(:partition).with(anything(), hostname).and_return(per_host_scenarios) 
      simulation_instance.should_receive(:simulate).ordered.with(scenario_a, seeds)
      simulation_instance.should_receive(:simulate).ordered.with(scenario_b, seeds)

      subject.run
    end

    it "spawns multiple threads if the hosts support it" do
      per_host_scenarios = [[scenario_a], [ scenario_b]]

      hosts.should_receive(:partition).with(anything(), hostname).and_return(per_host_scenarios) 
      thread = double("Thread")
      Thread.should_receive(:new).twice.and_return(thread)
      thread.should_receive(:join).twice

      subject.run
    end

  end
end
