require "spec_helper"

require "open3"

describe SimControl::PythonEnvironment do
  let(:script) { "a-script" }
  describe "#simulate" do
    it "uses popen3 to call the command and sets the cwd" do
      command = "a-command"
      basedir = "a-basedir"
      thread = double("Thread")
      
      simulation = SimControl::PythonEnvironment.new script
      simulation.stub(:command).and_return(command)
      simulation.stub(:basedir).and_return(basedir)
      Open3.should_receive(:popen3).with(command, chdir: basedir).and_return([nil, nil, nil, thread])
      thread.should_receive(:join)
      simulation.execute(foo: 1)
    end

    it "calls the script if nothing is passed in args" do
      simulation = SimControl::PythonEnvironment.new script
      expect(simulation.script).to eq("a-script")
    end

    it "passes args to the script in -- syntax" do
      simulation = SimControl::PythonEnvironment.new script
      expect(simulation.args({foo: "bar", baz: 1})).to eq("--foo bar --baz 1")
    end

    it "uses a given interpreter" do
      simulation = SimControl::PythonEnvironment.new script, interpreter: "pypy"
      expect(simulation.interpreter).to eq("pypy")
    end

    it "uses a given virtualenv and interpreter" do
      simulation = SimControl::PythonEnvironment.new script, virtualenv: "foo/bar",  interpreter: "pypy"
      expect(simulation.interpreter).to eq("foo/bar/bin/pypy")
    end
    
    it "composes the command" do
      simulation = SimControl::PythonEnvironment.new script
      simulation.stub(:args).and_return "--args 1"
      simulation.stub(:interpreter).and_return "/foo/jpython"
      expect(simulation.command(args: 1)).to eq("/foo/jpython a-script --args 1")
    end

    it "raised an exception is a virtualenv is passed but no interpreter" do
      expect do
        SimControl::PythonEnvironment.new script, virtualenv: "foo/bar"
      end.to raise_error /passing a virtualenv requires an interpreter/
    end

    it "returns the basedir" do
      simulation = SimControl::PythonEnvironment.new "/foo/bar/sim.py"
      expect(simulation.basedir).to eq("/foo/bar")
    end
  end

end
