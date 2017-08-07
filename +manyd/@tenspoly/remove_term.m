function removed = remove_term(p, term)
    % Removes term based on the given its basis
    assert(isvector(term), 'FIXME needs more functionality');
    key = p.bas2str(term);
    removed = p.termMap(key);
    p.termMap.remove(key);
    p.calcWhich(); % FIXME maybe necessary?
end
