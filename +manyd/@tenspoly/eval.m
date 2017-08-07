function f = eval(pin, x)
    % Evaluates the tensored basis function at a vector of x data
    % Syntax: p.eval(x)
    % Inputs: x = [x1_1, x2_1, x3_1, ... ;
    %              x1_2, x2_2, x3_2, ... ;
    %              ...
    sp = size(pin);
    [npts, ndimx] = size(x);
    assert(pin(1).ndim == ndimx);

    %             nterms = p.termMap.Count;
    %             f = zeros(npts,1);
    %             % Per term, multiply basis polys together with coefficient
    %             for i = 1:nterms % per term
    %                 term = ones(npts, 1);
    %                 for j = 1:p.ndim % per polynomial
    %                     term = term .* pbasis{exps(i,j)+1,j};
    %                 end
    %                 f = f + p.termMap(strs{i}) * term; % tack coefficient on, and add.
    % Absolute insanity below
    basisevals = calcBasisX(pin, x);

    np = numel(pin);
    f = zeros(np, npts);
    for k = 1:np
        p = pin(k);
        strs = keys(p.termMap);
        exps = p.str2bas(strs);

        nterms = p.termMap.Count;
        ff = zeros(npts,1);
        % Per term, multiply basis polys together with coefficient
        for i = 1:nterms
            term = ones(npts, 1);
            for j = 1:p.ndim
                % NOTE if you don't have a term, it breaks.
                % whichFNs needs be up to date
                term = term .* basisevals{exps(i,j)+1,j};
            end
            ff = ff + p.termMap(strs{i}) * term;
        end
        f(k,:) = ff;
    end
    if np == 1
        f = f(:);
    else
        f = reshape(f,[sp npts]);
        % end insanity
    end
end
