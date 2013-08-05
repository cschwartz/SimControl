class SimControl::Hosts
  def use(host, args = {})

  end

  def partition(all_scenarios, hostname)
    []
  end

  def process(&block)
    instance_eval(&block)
  end

end
