function x_samp = sample_gen(nx_samp, varargin)
% SAMPLE_GEN  Generates samples from Matlab's default rng, or from a
% library of low discrepancy samplers
%   import manyd.*
%   X = sample_gen(10) returns a column row of 10 MATLAB default rand
%   X = sample_gen(10, 2) returns 2 columns of 10 MATLAB default rand
%   X = sample_gen(100, 4, 'niederreiter') return 10 4-D points w/ Niederreiter-Xing
%
%   X = sample_gen(30, 5, 'ihs', 'seed', 10) sets the seed to 10
% See https://github.com/EpiMaT/manyd/tree/master/%2Bmanyd/%2Bgen

import manyd.gen.*

one_num_validator = @(x) isnumeric(x) && isscalar(x);

prsr = inputParser;

addRequired(prsr, 'nx_samp', one_num_validator);
addOptional(prsr, 'n_dim', 1, one_num_validator);
addOptional(prsr, 'l_samp', 'rand', @ischar);

%% Add New Parameters Here
addParameter(prsr, 'seed', NaN, one_num_validator);
addParameter(prsr, 'orig_pts', [], @isnumeric);

prsr.parse(nx_samp, varargin{:});

nx_samp = prsr.Results.nx_samp;
n_dim = prsr.Results.n_dim;
l_samp = prsr.Results.l_samp;
seed = prsr.Results.seed;
orig_pts = prsr.Results.orig_pts;

%% Add New Case here
switch l_samp
    case 'rand'
        if ~isnan(seed)
            rng(seed); % fix random number seed for repeatablity
        end
        x_samp = rand(nx_samp, n_dim);

    case 'grid' % generate a uniform grid at midpoints
        x_samp = grid.sample(nx_samp, n_dim);

    case 'edgegrid' % generate a uniform grid, includes boundary pts
        x_samp = edgegrid.sample(nx_samp, n_dim);

    case 'sparse'
        x_samp = sparse.sample(nx_samp, n_dim);

%     case 'fith' % fill in the holes
%         x_samp = fith.sample(n_dim, nx_samp, seed);

    case 'repulsefith'
        x_samp = repulsefith.sample(nx_samp, n_dim, seed, orig_pts);

    case 'sobol'
        if isnan(seed)
            seed = randi(2^16-1); % 2^32 made sobol gen hang..
        end
        x_samp = sobol.sample(nx_samp, n_dim, seed);

    case 'halton'
        if isnan(seed) % if no see, we have to generate one
            seed = randi(2^32-1);
        end
        x_samp = halton.sample(nx_samp, n_dim, seed);
        
    case 'ihs' % Beachkofski-Grandhi LHC sampling, improved by Burkhart
        if isnan(seed) % if no seed, we have to generate one
            seed = randi(2^32-1);
        end
        x_samp = ihs.sample(nx_samp, n_dim, seed);

    case 'niederreiter'
        if isnan(seed)
            seed = randi(2^16-1); % 2^32 made nieder gen fail..
        end
        x_samp = niederreiter.sample(nx_samp, n_dim, seed);

    otherwise
        error('Not a valid generator')
end

end
