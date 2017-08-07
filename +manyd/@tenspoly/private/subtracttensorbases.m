function p = subtracttensorbases(p1, p2)
    if isnumeric(p1) && isscalar(p1)
        % negate all coefficients of p2
        p = tpoly(p2);
        exps = keys(p.termMap);
        for i = 1:length(exps)
            key = exps{i};
            p.termMap(key) = -p.termMap(key);
        end
        % then do scalar quantity
        key = p.bas2str(zeros(1,p.ndim));
        v = 0;
        if p.termMap.isKey(key)
            v = p.termMap(key);
        end
        p.termMap(key) = p1 - v;
    elseif isnumeric(p2) && isscalar(p2)
        key = p1.bas2str(zeros(1,p1.ndim));
        v = 0;
        if p1.termMap.isKey(key)
            v = p1.termMap(key);
        end
        p = tpoly(p1);
        p.termMap(key) = v - p2;
    else
        % copy p1, then subtract everything from it
        p = tpoly(p1);
        strs = keys(p2.termMap);
        for k = strs
            v = 0;
            key = cell2mat(k);
            if p.termMap.isKey(key)
                v = p.termMap(key);
            end
            p.termMap(key) = v - p2.termMap(key);
        end
        calcWhich(p);
    end
end % SUBRTACTTENSORBASES
