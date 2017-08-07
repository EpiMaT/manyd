# manyd
MATLAB library to analyze a many dimensioned function using tensored 1-D polynomials.

## Setup
* Clone repo to your computer
  * Command line: `git clone git@github.com:epimat/manyd.git`
  * Github Desktop: File Menu -> Clone Repository
  * Web archive: `https://github.com/epimat/manyd` -> Green 'download' button -> Download ZIP
* Add repo's directory to Matlab path
  * Our group runs `set_workspace.m` to alter default figure output and to prepare pathing

### Generate Sample Points
Using MATLAB's packaging system,
here are three equivalent ways to generate 10 points in 4 dimensions
using 'improved Latin hypercube sampler' with seed 0

```matlab
manyd.sample_gen(4,10,'ihs',0);

import manyd.*
sample_gen(4,10,'ihs',0);

import manyd.gen.*
ihs.sample(4,10,0)

%    0.5500    0.6500    0.6500    0.1500
%    0.4500    0.0500    0.9500    0.0500
%    0.2500    0.2500    0.8500    0.2500
%    0.1500    0.1500    0.7500    0.3500
%    0.0500    0.4500    0.5500    0.4500
%    0.3500    0.3500    0.4500    0.7500
%    0.6500    0.5500    0.3500    0.8500
%    0.7500    0.8500    0.2500    0.5500
%    0.9500    0.7500    0.0500    0.6500
%    0.8500    0.9500    0.1500    0.9500

```
See Also: [List of available generators](+manyd/+gen/)

### Multi-dimensional tensored 1-D polynomials
We first describe a polynomial of the desired dimension and total degree,
and can print it out with its current coefficients.
```matlab
desc.dim = 3;
desc.deg = 2;
desc.basis = 'mono'; % monomial
poly = manyd.tenspoly(desc)

% tenspoly with properties:
%
%   basis: 'mono'
%    ndeg: 2
%    ndim: 3

poly.pprint()

% 0 + 0 x3 + 0 x3^2 + 0 x2 + 0 x2 x3 + 0 x2^2 + 0 x1 + 0 x1 x3 + 0 x1 x2 + 0 x1^2
```
We create a design matrix, solve for the coefficients, change the polynomial and evaluate the polynomial.

```matlab
x = manyd.sample_gen(3,10,'rand'); % 10 random 2-D points
A = poly.calcDesignMatrix(x);
b = (x.^2) * [1; 2; 3]; % f(x1,x2,x3) = 1 x2^2 + 2 x2^2 + 3 x3^2

poly.setCoefficients(A \ b); % solve and set
poly.pprint()

% 1.1926e-14 - 2.0158e-14 x3 + 3 x3^2 - 3.9849e-15 x2 + 1.346e-14 x2 x3 + 2 x2^2 - 6.2541e-15 x1 + 2.2707e-15 x1 x3 + 5.0962e-16 x1 x2 + 1 x1^2

poly.simplify(1e-10); % remove terms with coeff magnitude below a threshold
poly.pprint()

% 3 x3^2 + 2 x2^2 + 1 x1^2

poly.eval([0,0,1; 1,0,0; 1,0,1; 1,1,1])

%   3.0000
%   1.0000
%   4.0000
%   6.0000
```
