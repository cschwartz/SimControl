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

 * In order to create your first simulation scenario, run

```
bundle exec simcontrol scenario myScenario
```
