function A = calcDesignMatrix(p, xdata, pbasis)
    % Returns the design matrix for a matrix of X data
    [npts, ndimx] = size(xdata);
    assert(p.ndim == ndimx);
    exps = p.str2bas(keys(p.termMap));

    if ~exist('pbasis','var')
        pbasis = calcXData(p,xdata,p.whichFns);
    end

    nterms = p.termMap.Count;
    A = NaN(npts,nterms);
    for i=1:nterms
        term = ones(npts,1);
        for j=1:ndimx
            k = exps(i,j)+1;
            term = term .* pbasis{k,j};
        end
        A(:,i) = term;
    end
end
