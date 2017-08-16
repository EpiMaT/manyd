function bool = eq(p1, p2)
    assert(isa(p1,'manyd.tenspoly') && isa(p2,'manyd.tenspoly'), 'Both must be tenspolys')
    bool = logical(true);
    if ~strcmpi(p1.basis,'mono')
        a = p1.convert('mono');
    else
        a = p1;
    end
    if ~strcmpi(p2.basis,'mono')
        b = p2.convert('mono');
    else
        b = p2;
    end
    aK = keys(a.termMap);
    bK = keys(b.termMap);
    abK = union(aK, bK);
    for i = 1:length(abK)
        key = abK{i};

        av = 0; % get this term from a
        if a.termMap.isKey(key)
            av = a.termMap(key);
        end

        bv = 0; % get this term from b
        if b.termMap.isKey(key)
            bv = b.termMap(key);
        end
        % if not the same, return false and stop
        if abs(av-bv) > 1e-8
            bool = logical(false);
            return
        end
    end
end
