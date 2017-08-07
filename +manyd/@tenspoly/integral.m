function f = integral(p)
    % Evaluates the tensored basis function integrated over given domain
    % Defaults to [0,1]
    % FIXME: do ranges other than [0,1].
    strs = keys(p.termMap);
    exps = p.str2bas(strs);
    pbasis = calcIntBasis(p);

    nTerms = p.termMap.Count;
    f = zeros(1,1);
    % Per term, multiply basis polys together with coefficient
    for i = 1:nTerms
        term = ones(1, 1);
        for j = 1:p.ndim
            term = term .* pbasis{exps(i,j)+1,j};
        end
        f = f + p.termMap(strs{i}) * term;
    end
end
