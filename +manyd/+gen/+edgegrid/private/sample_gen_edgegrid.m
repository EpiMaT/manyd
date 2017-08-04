function [x_samp] = sample_gen_edgegrid(nx_samp,n_dim)
%*****************************************************************************80
%
%% SAMPLE_GEN_EDGEGRID generates a regular grid of points in any dimension
%
%  Modified:
%
%    30 November 2011
%
%  Parameters:
%
%    Input, nx_samp, desired number of sample points.  actual number of
%    points will be determined by rounded up to the smallest regular
%    hypercube.  Includes boundary points.
%
%    Input, n_dim, dimension of space.


if n_dim == 1
    
    x_samp = linspace(0,1,nx_samp)'; 
    
else
    
    nx_side = ceil(nx_samp^(1/n_dim));
    
    if (nx_side == 1)
        error('Too few points')
    end
    
    dx = 1/(nx_side - 1);
    x_samp = NaN(nx_side^n_dim, n_dim);
    x_samp = recurse(x_samp, dx);
    
end
end

function [output] = recurse(input, dx)
[A,B] = size(input);
output = NaN(A,B);

N = round(A^((B - 1)/B));
M = round(A^(1/B));

if (B == 1)
    for i=1:M
        output(1 + (i - 1)*N:i*N, 1) = (i - 1)*dx;
    end
else
    for i=1:M
        output(1 + (i - 1)*N:i*N, 1) = (i - 1)*dx;
        output(1 + (i - 1)*N:i*N, 2:B) = recurse(NaN(N,B - 1), dx);
    end
end

end
