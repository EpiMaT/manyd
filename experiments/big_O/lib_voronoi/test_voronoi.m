function [t_exact,errs,ts]=test_voronoi(dim,npts,qmc_pts)
% dim = dimension of a point
% npts = number of points to get the voronoi vol of
% qmc_pwr = 2^qmc_pwr QMC points are used, hardcoded as 'niederreiter'
%
% t_exact
%
%
% 1:
% 2:
% show computing exact value time
% compute estimation time and respect error
% we evaluate d dimension and n random points' voronoi volume

% we generate random points
sdata=rand(dim,npts);

%exact value of voronoi
t_begin=tic;
exactv=voronoiVolumes(sdata);
t_exact=toc(t_begin);

%2^m QMC points we are going to use to estimate the voronoi volume
% m=16;
% error vector
% e=zeros(1,m);

t_begin=tic;
v(1,:)=voronoivol(sample_gen(qmc_pts,dim,'niederreiter',randi(100000)), sdata');
errs(1)=(norm(exactv-v(1,:),2));
ts(1)=toc(t_begin);

t_begin=tic;
v(2,:)=voronoivol(sample_gen(qmc_pts,dim,'rand',randi(100000)), sdata');
errs(2)=(norm(exactv-v(2,:),2));
ts(2)=toc(t_begin);

t_begin=tic;
v(3,:)=voronoivol(sample_gen(qmc_pts,dim,'grid'), sdata');
errs(3)=(norm(exactv-v(3,:),2));
ts(3)=toc(t_begin);

t_begin=tic;
v(4,:)=voronoivol(sample_gen(qmc_pts,dim,'edgegrid'), sdata');
errs(4)=(norm(exactv-v(4,:),2));
ts(4)=toc(t_begin);

% t_begin=tic;
% v(5,:)=voronoivol(sample_gen(qmc_pts,dim,'BGLHC',randi(100000)), sdata');
% errs(5)=(norm(exactv-v(5,:),2));
% ts(5)=toc(t_begin);

t_begin=tic;
errs(5)=(norm(exactv-1/npts,2));
ts(5)=toc(t_begin);

% figure(1)
% plot(1:n,sort(exactv), 1:n,sort(v), 1:n,ones(1,n)/n)
% ylabel('weight')
