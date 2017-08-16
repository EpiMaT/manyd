function pout = multiplyscalar(const, p)
    import manyd.tenspoly
    % Return new tensor basis object with scalar multiplied

    % If one is a constant, first duplicate the object
    pout = tenspoly(p);

    ks = keys(pout.termMap);
    % Then traverse every key and multiply its value by const
    for i = 1:length(ks)
        key = ks{i};
        pout.termMap(key) = p.termMap(key) * const;
    end
end
