require "spec_helper"

describe SimControl::BaseEnvironment do
  describe "#simulate" do
    it "calls #execute for each seed" do
      scenario = double("scenario")
      scenario.should_receive(:args).with(seed: 1)
      scenario.should_receive(:args).with(seed: 2)
      subject.should_receive(:execute).twice
      subject.simulate(scenario, [1, 2])
    end
  end
end
