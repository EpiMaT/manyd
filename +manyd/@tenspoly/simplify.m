function p = simplify(p, tol)
    % Removes terms with coefficients whose abs val is < given tolerance
    % If no tolerance is supplied, default is 0
    if ~exist('tol','var')
        tol = 0;
    end
    assert(tol >= 0, 'Tolerance must be nonnegative')
    for k = keys(p.termMap)
        key = cell2mat(k);
        if abs(p.termMap(key)) <= tol
            p.termMap.remove(key);
        end
    end
    calcWhich(p);
end
