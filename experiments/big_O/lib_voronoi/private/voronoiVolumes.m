function areas=voronoiVolumes(sdata)

% seeds are DxN, D is dimensions, N is number of points.
% voronoi is calculated in [0,1]^D=

% note the below set of 8 points.
%   [ 0.75   0.25  0.25;
%     0.75   0.25  0.75;
%     0.75   0.75  0.25;
%     0.75   0.75  0.75;
%     0.25   0.75  0.25;
%     0.25   0.75  0.75;
%     0.25   0.25  0.25;
%     0.25   0.25  0.7501]';
% if the final value is .75, the qhull program cannot calculate it.
% perfect grids break some assumption.

[d,n] = size(sdata);


[~,~,vert] = voronoiPolyhedrons( sdata, zeros(1,d), ones(1,d) );

areas = NaN(1,n);
for i = 1:n
    [~,areas(i)]=convhulln(vert{i}.');
end

end

