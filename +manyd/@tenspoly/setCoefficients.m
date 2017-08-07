function p = setCoefficients(p, coef)
    strs = keys(p.termMap);
    for k = 1:length(strs)
        p.termMap(strs{k}) = coef(k);
    end
end
