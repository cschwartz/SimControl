require "spec_helper"

describe SimControl::Hosts do
  it "applies use directives in process" do
    hosts = SimControl::Hosts.new
    hosts.should_receive(:use).with("host-a")
    hosts.process do
      use "host-a"
    end
  end

  it "splits scenarios evenly if all hosts have 1 core" do
    hosts = SimControl::Hosts.new
    hosts.use "host-a"
    hosts.use "host-b"
    scenario_a = {foo: 1}
    scenario_b = {foo: 2}
    scenario_c = {foo: 3}
    scenario_d = {foo: 4}
    all_scenarios = [scenario_a, scenario_b, scenario_c, scenario_d]
    host_a_scenarios = hosts.partition all_scenarios, "host-a"
    expect(host_a_scenarios).to include(scenario_a)
    expect(host_a_scenarios).to include(scenario_b)
    host_b_scenarios = hosts.partition all_scenarios, "host-b"
    expect(host_b_scenarios).to include(scenario_c)
    expect(host_b_scenarios).to include(scenario_d)
  end

end
