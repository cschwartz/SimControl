require "spec_helper"

require "simcontrol"

describe SimControl::Init do
  let(:directory_name) { "/directory/name" }

  describe ".createScaffolding" do
    it "creates an Init instance, passes a base directory parameter and executes" do
      init = double(SimControl::Init)
      init.should_receive(:execute)
      init_class = double(Class)
      init_class.should_receive(:new).and_return(init)
      SimControl::Init.createScaffolding(directory_name, init: init_class)
    end

    it "sets the root_dir of the actions class" do
      init = SimControl::Init.createScaffolding(directory_name)      
      expect(init.destination_root).to eq(directory_name)
    end
  end

  describe "#execute" do
    it "creates a scenarios directory" do
      init = SimControl::Init.new(directory_name)
      init.should_receive(:empty_directory).with("scenarios")
      init.execute()
    end
  end

end
