repetitions 10
numberOfServers = (1..100).step(10)

numberOfServers.each do |currentNumberOfServers|
  simulate numberOfServers: currentNumberOfServers,
    duration: 1.day + 1.hour,
    transientPhaseDuration: 1.hour
end
