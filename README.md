# Information Particle Filter Tree

This repository contains the code for the publication

```
@inproceedings{fischer2020information,
  title     = {Information Particle Filter Tree: An Online Algorithm for POMDPs with Belief-Based Rewards on Continuous Domains},
  author    = {Johannes Fischer and {\"O}mer Sahin Tas},
  booktitle = {Proceedings of the 37th International Conference on Machine Learning},
  year      = {2020},
  volume    = {119},
  series    = {Proceedings of Machine Learning Research},
  publisher = {PMLR},
  address   = {Vienna, Austria},
  month     = {July}
}
```

The code uses the [JuliaPOMDP](https://github.com/JuliaPOMDP/POMDPs.jl) framework. All necessary packages are installed by following the setup instructions.

## Setup

This instructions were tested with Julia v1.2.0. Run the following in a Julia REPL, **started from the top folder**:

```
using Pkg
Pkg.add("POMDPs")
using POMDPs
POMDPs.add_registry()
Pkg.activate(".") # this activates the environment we provide, when starting Julia in the correct folder
Pkg.instantiate()
```

## Directory Structure

- dev: Contains packages from the JuliaPOMDP ecosystem which were slighly modified for this research (see below), in particular the LaserTag problem implementation
- Evaluation: Contains a small script for computing the statistics of a previous experiment from a CSV file
- Experiments: Contains the scripts for the different experiments
  - ld_table: Light Dark problem evaluation
  - cld_table: Continuous Light Dark problem evaluation
  - lasertag_table: Laser Tag problem evaluation
  - ld_parameter_sensitivity: Light Dark problem evaluation
- IPFT: Contains implementation of IPFT algorithm and information measures
  - core: IPFT algorithm
  - information measures: entropy computation based on kernel density estimation and interface for other information measures
  - util: action selection strategies, heuristics, and some more necessary utilities
- Scenarios: Defines the LightDark and ContinuousLightDark problems and some additions to the LaserTag problem, which is defined in dev/
- SunbergTypes: Contains types from https://github.com/zsunberg/ContinuousPOMDPTreeSearchExperiments.jl, which are the experiments for the publication
    
    > Zachary N. Sunberg and Mykel J. Kochenderfer. “Online algorithms for POMDPs with continuous state, action, and observation spaces”. In: International Conference on Automated Planning and Scheduling (ICAPS). 2018.



## Experiments

Simply run the corresponding scripts within the environment, e.g. in the top folder run
```
julia --project=. Experiments/ld_table.jl
```
Unfortunately in Julia it is not possible to start Julia with multiple processes in an activated environment (see https://github.com/JuliaLang/julia/issues/28781).
To run the experiments with multiple processes in parallel execute
```
export JULIA_PROJECT=/path/to/top/folder
julia -p Nproc Experiments/ld_table.jl
```
or activate the environment by default in ~/.julia/config/startup.jl.

Script | Scenario
---|---
ld_table.jl  |  Light Dark problem
cld_table.jl | Continuous Light Dark problem
lasertag_table.jl | Laser Tag problem
ld_parameter_sensitivity.jl  |  Parameter sensitivity analysis for the Light Dark or Continuous Light Dark problem
sample_trajectory.jl | Compare trajectories generated by POMCPOW and IPFT for the Continuous Light Dark problem from the same inital state



### Arguments

All arguments default to the values used in the evaluations in the paper. Only the step size of the Light Dark problems is varied between 10 and 3 for the two different action spaces [-10,-1,0,1,10] and [-3,-1,0,1,3], respectively, considered in the paper.

Argument | Description
---|---
-s, --step | define the step size of large step action for Light Dark problems
-o, --obs  | set additive observation noise (see problem specifications for details) for Light Dark problems
-t, --trans  |  set transition noise (only Continuous Light Dark problem)
--pknown  | define whether or not the position of the robot is known in the Laser Tag problem
-N  | Number of evaluations that are run for a problem, default to 1000


## Evaluation

The results of the experiments are saved in the Experiments/results folder as CSV files. To recompute the statistics for a previous experiment insert the filename in the evaluate.jl script and run
```
julia Evaluation/evaluate.jl
```
We already provide some results for the Light Dark problems, as presented in the paper. The filenames ld3 and ld10 (cld3 and cld10) refer to the different action spaces considered for the Light Dark and Continuous Light Dark problems, respectively.

## Modifications in JuliaPOMDP packages

The JuliaPOMDP framework can handle terminal states, but not terminal actions. For problems like the Light Dark problem, which have terminal actions, this is usually implemented by transitioning to a dedicated terminal state after such a terminal actions.

Since we work with the entropy of beliefs, we refrain from using such terminal states, because then the entropy always becomes zero after a terminal action, which is misleading the information gathering reward.

For this reason, we implement terminal actions in the whole framework, which has to be supported in many packages (e.g. the solvers/simulators we use).
Hence, many packages are affected, but only with minor modifications.

Furthermore, we implemented covariance computation for particle sets in ParticleFilter.jl.

## Naming conventions used in the code

### General
Variable name | Meaning
---|---
rng | random number generator
ld | light dark problem
cld | continuous light dark problem
kde | kernel density estimation
gmm | gaussian mixture model
pdf | probability density function

### POMDPs
Variable name | Meaning
---|---
s | state
a | action
o | observation
r | reward (or any result of a function)
sp | successor state
b | belief (particle set)
bp | posterior belief

### Particle Sets
Variable name | Meaning
---|---
pf | particle filter
up | updater
N | number of particles
sir | sequential importance resampler
pc | particle collection
p | particle
w | weight
ws | weight sum
pm | particle memory
wm | weight memory

### Information Measures
Variable name | Meaning
---|---
im, ifm | information measure
ib |  belief together with its information
i | information
e | entropy
