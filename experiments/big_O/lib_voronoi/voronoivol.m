function [v]=voronoivol(A,B)
% Using QMC points A to approximate the voronoi volume of points B

% test sample B=[0,0;1,0;0,1;1,1];

[s,t]=size(A);
[n,m]=size(B);

if t~=m 
    error('The column dimension of A should equal to B');
end
        
% using pdist2 computing all distance between every points
D=pdist2(B,A);

% find all smallest value's index in every column
[~,I]=min(D);

% count the number of QMC points around every original point 
F=histc(I,1:n);


v=F'/s;
