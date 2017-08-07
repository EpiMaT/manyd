function calcWhich(p)
    exps = p.str2bas(keys(p.termMap));
    deg = 0;
    if isempty(exps)
        return
    end
    for i = 1:p.ndim
        um = unique(exps(:,i));
        p.whichFns{i} = um;
        deg = max(deg, max(um));
    end
    p.ndeg = deg;
    calcBasis(p);
end
