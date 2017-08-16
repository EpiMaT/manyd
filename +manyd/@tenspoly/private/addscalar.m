function pout = addscalar(const, p)
    import manyd.tenspoly

    % Return new tensor basis object with scalar added

    % const is a scalar, p is a tenspoly object
    key = p.bas2str(zeros(1,p.ndim));
    v = 0;
    if p.termMap.isKey(key)
        v = p.termMap(key);
    end
    % copy all of p2
    pout = tenspoly(p);
    % add p1 and v
    pout.termMap(key) = const + v;
    calcWhich(p);  % FIXME calcWhich needed, but too slow
end
