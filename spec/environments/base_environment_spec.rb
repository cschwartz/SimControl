require "spec_helper"

describe SimControl::BaseEnvironment do
  describe "#simulate" do
    it "calls #execute for each seed" do
      subject.should_receive(:execute).twice
      subject.simulate({}, [1, 2])
    end

    it "injects the seed in the arguments hash" do
      subject.should_receive(:execute) do |args|
        expect(args[:seed]).to eq(1)
      end

      subject.should_receive(:execute) do |args|
        expect(args[:seed]).to eq(2)
      end

      subject.simulate({}, [1, 2])
    end

    it "keeps the arguments hash" do
      subject.should_receive(:execute) do |args|
        expect(args[:foo]).to eq("bar")
      end

      subject.simulate({foo: "bar"}, [1])

    end
  end
end
