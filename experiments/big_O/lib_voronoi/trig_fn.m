function [f, area] = trig_fn(x)
    a = 2;
    dim=size(x,2);
    if dim == 1
        f = cos(a*x(:,1));
        area = NaN;
    else % dim = 2
        f = sin(a*x(:,1)).*cos(a*x(:,2))/2 + .3;
        du = @(x,y) sqrt((a/2)^2*sin(a*x).^4 + (a/2)^2*cos(a*y).^4 + 1);
        area = integral2(du,0,1,0,1) % f evals
    end
end