require "active_support/all"

class SimControl::Hosts
  def initialize
    @hosts = {}
  end

  def use(host, args = {})
    args[:cores] = args[:cores] || 1
    @hosts[host] = args
  end

  def number_of_cores
    @hosts.map { |k, v| v[:cores] }.reduce(:+)
  end

  def partition(all_scenarios, hostname)
    host_index = @hosts.keys.index(hostname)
    return [] unless host_index
    scenario_groups = all_scenarios.in_groups_of(number_of_cores)
    scenario_groups[host_index]
  end

  def process(&block)
    instance_eval(&block)
  end

end
