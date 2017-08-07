function exps = terms(p)
    % List per dimension which basis function each term uses.
    exps = p.str2bas(keys(p.termMap));
end
