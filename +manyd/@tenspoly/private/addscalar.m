function pout = addscalar(const, p)
    % Return new tensor basis object with scalar added

    % const is a scalar, p is a tpoly object
    key = p.bas2str(zeros(1,p.ndim));
    v = 0;
    if p.termMap.isKey(key)
        v = p.termMap(key);
    end
    % copy all of p2
    pout = tpoly(p);
    % add p1 and v
    pout.termMap(key) = const + v;
    calcWhich(p);  % FIXME calcWhich needed, but too slow
end
