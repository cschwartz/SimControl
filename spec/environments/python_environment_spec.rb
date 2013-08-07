require "spec_helper"

describe SimControl::PythonEnvironment do
  let(:script) { "a-script" }
  describe "#simulate" do
    it "calls the script if nothing is passed in args" do
      simulation = SimControl::PythonEnvironment.new script
      simulation.should_receive(:`).with(script)
      simulation.execute({})
    end

    it "passes args to the script in -- syntax" do
      simulation = SimControl::PythonEnvironment.new script
      simulation.should_receive(:`).with("#{ script } --foo bar --baz 1")
      simulation.execute({foo: "bar", baz: 1})
    end

    it "uses a given interpreter" do
      simulation = SimControl::PythonEnvironment.new script, interpreter: "pypy"
      simulation.should_receive(:`).with("pypy #{ script }")
      simulation.execute({})
    end

    it "uses a given virtualenv and interpreter" do
      simulation = SimControl::PythonEnvironment.new script, virtualenv: "foo/bar",  interpreter: "pypy"
      simulation.should_receive(:`).with("foo/bar/bin/pypy #{ script }")
      simulation.execute({})
    end

    it "raised an exception is a virtualenv is passed but no interpreter" do
      expect do
        SimControl::PythonEnvironment.new script, virtualenv: "foo/bar"
      end.to raise_error /passing a virtualenv requires an interpreter/
    end
  end

end
