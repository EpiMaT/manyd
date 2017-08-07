function removed = removeTerm(p, term)
    % Removes term based on the given its basis
    assert(isvector(term), 'FIXME needs more functionality');
    key = p.bas2str(term);
    removed = p.termMap(key);
    p.termMap.remove(key);
    calcWhich(p); % FIXME maybe necessary?
end
