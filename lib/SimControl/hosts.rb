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
    @hosts.map { |k, v| v[:cores] }.reduce(0, :+)
  end

  def partition(all_scenarios, hostname)
    return [] if number_of_cores == 0
    scenario_groups = all_scenarios.in_groups(number_of_cores, false)
    scenario_groups[host_indices hostname]
  end

  def host_indices(hostname)
    return 0..0 unless @hosts.include? hostname
    start_index = 0
    @hosts.each do |current_hostname, options|
      cores = options[:cores]
      return (start_index ... (start_index + cores)) if current_hostname == hostname
      start_index += cores
    end
  end

  def process(&block)
    instance_eval(&block)
  end

end
