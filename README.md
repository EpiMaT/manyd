# manyd
MATLAB library to analyze a many dimensioned function using tensored 1-D polynomials.

## Setup
* Clone repo to your computer
  * Command line: `git clone git@github.com:epimat/manyd.git`
  * Github Desktop: File Menu -> Clone Repository
  * Web archive: `https://github.com/epimat/manyd` -> Green 'download' button -> Download ZIP
* Add repo's directory to Matlab path

## Uses
First argument to every method is the # of dimensions, if needed.

### Generate Sample Points
Using MATLAB's packaging system, here are three equivalent ways to generate 10 points in 4 dimensions using 'improved Latin hypercube' with seed 0 [(more point generation examples)](+manyd/+gen/)
```matlab
manyd.sample_gen(4,10,'ihs',0);

import manyd.*
sample_gen(4,10,'ihs',0);

import manyd.gen.*
ihs.sample(4,10,0)

    0.5500    0.6500    0.6500    0.1500
    0.4500    0.0500    0.9500    0.0500
    0.2500    0.2500    0.8500    0.2500
    0.1500    0.1500    0.7500    0.3500
    0.0500    0.4500    0.5500    0.4500
    0.3500    0.3500    0.4500    0.7500
    0.6500    0.5500    0.3500    0.8500
    0.7500    0.8500    0.2500    0.5500
    0.9500    0.7500    0.0500    0.6500
    0.8500    0.9500    0.1500    0.9500

```
