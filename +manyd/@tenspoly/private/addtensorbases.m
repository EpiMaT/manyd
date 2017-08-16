function p = addtensorbases(p1, p2)
    import manyd.tenspoly

    % copy p1, then add everything from p2
    p = tenspoly(p1);
    strs = keys(p2.termMap);
    for i = 1:length(strs)
        key = strs{i};
        v = 0;
        if p.termMap.isKey(key)
            v = p.termMap(key);
        end
        p.termMap(key) = p2.termMap(key) + v;
    end
    calcWhich(p);
end
