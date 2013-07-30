require "spec_helper"

describe SimControl::Controller do
  describe "#execute" do
    it "instance_evals the simulation_description" do

      simulation_description = <<Controlfile
hosts {

}
Controlfile
      scenario_description = "simulate"
      results_directory = "results/scenario"
      instance = double(SimControl::Controller)
      SimControl::Controller.should_receive(:new).with(simulation_description, scenario_description, results_directory).and_return(instance)
      instance.should_receive(:run)
      SimControl::Controller.execute(simulation_description, scenario_description, results_directory)
    end
  end 
end
