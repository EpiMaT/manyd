function [v]=surfacecalc(A,B,alpha)
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
[V,I]=min(D);

i = 1;
for a = alpha
    maybe = max(abs(D) < a);

    vv = sum(maybe(:));
    v(i,1) = vv./(s*2*a);

    i = i+1;
end

% count the number of QMC points around every original point 
% F=histc(I,1:n);

% v=F'/s;
