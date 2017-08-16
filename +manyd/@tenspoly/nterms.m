function n = nterms(p,opt)
    % Returns a count of the number of terms in the tenspoly object
    % optional input of 'nonzero' will give a count of terms that have > 0 as a coefficient
    if exist('opt', 'var')
        assert(strcmpi(opt,'nonzero'), 'tenspoly:NotImplemented')
        vs = cell2mat(values(p.termMap));
        n = length(find(vs > 0));
    else
        n = double(p.termMap.Count);
    end
end
