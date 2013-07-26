SimControl
==========

Usage Example
=============

 * Create a new directory `example`, create a `Gemfile` with the
   following content:

```
source 'https://rubygems.org'
gem 'SimControl'
```
  and run `bundle` to install the dependencies.

 * Next, run `bundle exec simcontrol init` to create the basic directory
   structure:

```
├── Controlfile
├── Gemfile
├── Gemfile.lock
├── results
└── scenarios
```

The Controlfile describes both the hosts on which the simulation will
run, as well as general information about the simulation program.
The default Controlfile is given below

```ruby
hosts do
  #A host with name "hostname"
  #host "hostname"

  #Another host, with 3 cores to be used for simulation
  #host "another-hostname", cores: 3
end

#currently only a python environment is implemented
simulation PythonEnvironment, "/path/to/simulation.py" do
  #use a virtualenv, not the global python
  #virtualenv "/path/to/virtualenv"
  #do not use the default system python but pypy
  #interpreter "pypy"
end
```

 * In order to create your first simulation scenario, run

```
bundle exec simcontrol scenario myScenario
```

which creates a results subfolder named myScenario as well as a scenario
description file myScenario.rb in the scenarios folder, resulting in the
following overall project structure:

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
