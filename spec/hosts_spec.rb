require "spec_helper"

describe SimControl::Hosts do
  it "applies use directives in process" do
    hosts = SimControl::Hosts.new
    hosts.should_receive(:use).with("host-a")
    hosts.process do
      use "host-a"
    end
  end

  describe "#number_of_cores" do
    it "provides the total number of cores" do
      hosts = SimControl::Hosts.new
      hosts.use "host-a"
      hosts.use "host-b", cores: 2
      expect(hosts.number_of_cores).to eq(3)
    end

    it "returns 0 if no hosts exist" do
      hosts = SimControl::Hosts.new
      expect(hosts.number_of_cores).to eq(0)
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
    expect(host_a_scenarios.first).to include(scenario_a)
    expect(host_a_scenarios.first).to include(scenario_b)
    host_b_scenarios = hosts.partition all_scenarios, "host-b"
    expect(host_b_scenarios.first).to include(scenario_c)
    expect(host_b_scenarios.first).to include(scenario_d)
  end

  it "returns the empty list if no hosts exist" do
    hosts = SimControl::Hosts.new
    scenario_a = {foo: 1}
    expect(hosts.partition [scenario_a], "a-host").to eq([])
  end


  describe "#host_indices" do
    it "returns the indices of scenarios to use" do
      hosts = SimControl::Hosts.new
      hosts.use "host-a", cores: 2
      hosts.use "host-b", cores: 3
      hosts.use "host-c", cores: 2
      hosts.use "host-d", cores: 4
      hosts_range = hosts.host_indices "host-c"
      expect(hosts_range).to include 5
      expect(hosts_range).to include 6
    end

    it "returns the empty array if the host is not found" do
      hosts = SimControl::Hosts.new
      expect(hosts.host_indices "host").to eq(0..0)
    end
  end
end
