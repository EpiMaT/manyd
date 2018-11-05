function [sa, exact]=test2_surface(f,dim,qmc_pts)
% dim = dimension of a point
% npts = number of points to get the voronoi vol of
% qmc_pwr = 2^qmc_pwr QMC points are used, hardcoded as 'niederreiter'

% we generate random points

r = sample_gen(qmc_pts,dim+1,'niederreiter',randi(100000));

lowd_x = r(:,1:end-1);
% sx = sample_gen(npts,dim,'niederreiter',10000);
lowd_y = f(lowd_x);

sdata = [lowd_x lowd_y];

t_begin=tic;
sa = surfacecalc(r, sdata, [.003 .01 .03 .1 .3]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for j = 0:4
% 
%     v(:,j+1) = test_surface(2,2^10,2^(10+j));
% 
% end
% 
% v