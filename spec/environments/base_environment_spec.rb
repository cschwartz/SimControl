require "spec_helper"

describe SimControl::BaseEnvironment do
  describe "#simulate" do
    it "calls #execute for each seed" do
      environment = SimControl::BaseEnvironment.new ""
      scenario = double("scenario")
      scenario.should_receive(:args).with(seed: 1, results: "")
      scenario.should_receive(:args).with(seed: 2, results: "")
      environment.should_receive(:execute).twice
      environment.simulate(scenario, [1, 2])
    end

    it "the results directory is merged in the scenario" do
      scenario = double("scenario")
      scenario.should_receive(:args).with(seed: 1, results: "path")
      environment = SimControl::BaseEnvironment.new "path"
      environment.stub(:execute)
      environment.simulate scenario, [1]
    end
  end
end
