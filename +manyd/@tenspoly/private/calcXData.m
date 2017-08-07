function peval = calcXdata(pin, xdata, whichFns)
    % calculate xdata at each basis function
    p = pin(1);
    peval = cell(p.ndeg+1, p.ndim);

    for i = 1:p.ndim
        which = whichFns{i}; % an array of which basis functions to use
        for j = 1:length(which)
            k = which(j)+1;
            peval{k,i} = polyval(p.basisFns{k}, xdata(:,i));
        end
    end
end
