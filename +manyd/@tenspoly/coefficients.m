function coeff = coefficients(p)
    % List coefficients of each term, corresponding to output of p.terms
    coeff = cell2mat(values(p.termMap))';
end
