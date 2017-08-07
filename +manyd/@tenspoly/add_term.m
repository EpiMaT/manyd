function p = add_term(p, term, coef)
    % Add a term with an optional coefficient
    %  term is a vector that is the length of the # of dimension
    % FIXME, unnecessary calcWhich is slow.
    assert(isvector(term), 'not implemented; we need more functionality?');
    assert(length(term)==p.ndeg, 'wrong size')
    if ~exist('coef','var')
        coef = 0;
    else
        assert(isfloat(coef), 'Given coefficient must be a float');
    end
    key = p.bas2str(term);

    p.termMap(key) = coef;
    calcWhich(p); % FIXME slow?
end
