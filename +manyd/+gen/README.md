
# Calculate sample points in a multi dimensional space

Much taken from John Burkardt's LGPL libraries: http://people.sc.fsu.edu/~jburkardt/m_src/m_src.html

## Fixed -- not seedable

### edgegrid
Grid, N = 2^s points, includes boundary points [0,1]^s
```
dx = 1/(N-1)
x = [0,dx,...,1]
```
### grid
Grid, N = 2^s points, does not include boundary points; midpoints of N cells
```
dx = 1/N
x = [dx/2,...,1-dx/2]
```
### sparse
Clenshaw-Curtis quadrature points

## Seeded by leaping ahead

### halton
### sobol
### niederreiter

## Seeded generation

### repulsefith
Basic fill in the holes, then iteratively apply force/charge to points
### ihs
Improved Distributed Hypercube Sampling
### rand
MATLAB's default IID generation
