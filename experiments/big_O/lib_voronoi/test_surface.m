function [v]=test_surface(f,dim,npts,qmc_pts)
% dim = dimension of a point
% npts = number of points to get the voronoi vol of
% qmc_pwr = 2^qmc_pwr QMC points are used, hardcoded as 'niederreiter'

% we generate random points
sx = sample_gen(npts,dim,'niederreiter',10000);
sy = f(sx);
sdata = [sx sy];
% 

% t_begin=tic;
% v(1,:)=surfacecalc(sample_gen(qmc_pts,dim,'niederreiter',randi(100000)), sdata');
% errs(1)=(norm(exactv-v(1,:),2));
% ts(1)=toc(t_begin);

r = sample_gen(qmc_pts,dim+1,'niederreiter',randi(100000));

% t_begin=tic;
v = surfacecalc(r, sdata, [.003 .01 .03 .1 .3]);
% errs(2,:) = v(2,:);
% errs(2)=(norm(exactv-v(2,:),2));
% ts(2)=toc(t_begin);

% t_begin=tic;
% v(3,:)=surfacecalc(sample_gen(qmc_pts,dim,'grid'), sdata');
% errs(3)=(norm(exactv-v(3,:),2));
% ts(3)=toc(t_begin);
% 
% t_begin=tic;
% v(4,:)=surfacecalc(sample_gen(qmc_pts,dim,'edgegrid'), sdata');
% errs(4)=(norm(exactv-v(4,:),2));
% ts(4)=toc(t_begin);
