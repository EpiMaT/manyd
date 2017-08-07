function peval = calcIntBasis(p)
    % Calculate xdata at each basis function
    peval = cell(p.ndeg+1, p.ndim);
    for i = 1:p.ndim
        which = p.whichFns{i};
        for j = 1:length(which)
            k = which(j)+1;
            % FIXME, can speed this up by keeping all integrated polys?
            ipoly = polyint(p.basisFns{k});
            peval{k,i} = polyval(ipoly, 1) - polyval(ipoly, 0);
        end
    end
end
