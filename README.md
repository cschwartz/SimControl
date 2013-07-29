SimControl
==========

Usage Example
=============

 * Create a new directory `control`, in the following assumed to be at
   /home/simpy/control/, create a `Gemfile` with the
   following content:

   ```ruby
   source 'https://rubygems.org'
   gem 'SimControl'
   ```
   and run `bundle` to install the dependencies.

 * Next, run `bundle exec simcontrol init` to create the basic directory structure:

   ```
   ├── Controlfile
   ├── Gemfile
   ├── Gemfile.lock
   ├── results
   └── scenarios
   ```
   
   The Controlfile describes both the hosts on which the simulation will run, as well as general information about the simulation program.  The default Controlfile is given below 
   
   ```ruby
   hosts do
     #A host with name "hostname"
     #host "hostname"
   
     #Another host, with 3 cores to be used for simulation
     #host "another-hostname", cores: 3
   end
   
   #currently only a python environment is implemented
   simulation PythonEnvironment, "/home/simpy/simulation/simulation.py",
     #use a virtualenv, not the global python
     virtualenv: "/home/simpy/simpy-env",
     #do not use the default system python but pypy
     interpreter: "pypy"
   ```

 * In order to create your first simulation scenario, run

   ```
   bundle exec simcontrol scenario myScenario
   ```
   
   which creates a results subfolder named myScenario as well as a scenario description file myScenario.rb in the scenarios folder, resulting in the following overall project structure: 
   
   ```
   .
   ├── Controlfile
   ├── Gemfile
   ├── Gemfile.lock
   ├── results
   │   └── myScenario
   └── scenarios
       └── myScenario.rb
   ```

   The default scenario description in myScenario.rb has the following content:
   
   ```
   repetitions 10
   numberOfServers = (1..100).step(10)
   
   numberOfServers.each do |currentNumberOfServers|
     simulate numberOfServers: currentNumberOfServers,
       duration: 1.day + 1.hour,
       transientPhaseDuration: 1.hour
   end
   ```

   This describes 10 scenarios, each with 10 repetitions are described. A system with a varying number of server components is simulated for a duration of 25 hours,  the first hour is exempt from statistic collection to account for the transient phase.

 * Next, we consider the execution of the simulation on one of the hosts specified in the Controlfile by running `bundle exec simulate myScenario`.  First, all scenarios, i.e. calls to simulate, are enumerated. Then, they are assigned to the hosts specified via the host call, were each host is considered multiple times if multiple cores are specified.  In our example, the 3 of the 10 scenarios will be assigned to hostname and the first core of another-hostname, while 2 scenarios will be assigned the remaining cores of another-hostname.  Then, simcontrol obtains the local hostname and the assigned scenarios and one scenario group is started per core.  The command to simulate a scenario is obtained as follows:

   The class and options hash passed to the simulation method in Controlfile are used to construct a `PythonEnvironment` instance, which is able to start the simulation environment. Note, that the simulation method merges the options hash with computed options, e.g. the path to the scenarios results directory and the seed to use for the stimulation.  The full set of parameters used to invoke the simulation are obtained from the parameters of the simulate method in myScenario.rb, were each of the options passed to the simulation as unix-style long parameters (i.e. foo: 4 is converted to --foo 4).

   In our example this results in the following simulation scenarios. Note, that in our example each of the scenarios is executed with varying parameter values for SEED (seed generation is discussed later).  

   | Host         | Core | Command |
   |--------------|------|---------|
   | host         | %    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 1 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario/ |
   | host         | %    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 11 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | host         | %    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 21 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 1    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 1 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 1    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 11 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 1    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 21 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 2    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 1 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 2    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 11 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 3    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 1 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |
   | another-host | 3    | /home/simpy/simpy-env/bin/pypy /home/simpy/simulation/simulation.py --numberOfServers 11 --duration 90000 --transientPhaseDuration 3600 --seed SEED --results /home/simpy/control/results/myScenario |

