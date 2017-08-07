function pout = convert(p, basis)
    % Returns new tpoly object identical to input, but in different basis
    %  Can be very slow; auto-simplifies
    %  Currently only works when converting to 'mono' from legendre
    % FIXME, clean up variable names, please
    % FIXME leading '1' shouldn't show
    assert(strcmpi (basis, 'mono') && ~strcmpi (basis, p.basis))
    pdef.basis = 'mono';
    pdef.dim   = p.ndim;
    pdef.deg   = p.ndeg;
    pout = tpoly(pdef);
    strs = keys(p.termMap);
    exps = p.str2bas(strs);
    [nterms, ndimb] = size(exps);
    for i = 1:nterms
        key = strs{i};
        from = exps(i,:)+1;
        tot = prod(from);
        expmono = NaN(tot, ndimb);
        if p.termMap(key) == 0
            continue
        end
        coefmono = zeros(tot, 1) + p.termMap(key);
        fact = 1;
        for j = 1:ndimb
            poly = p.basisFns{from(j)};
            plen = length(poly);
            for k = 1:plen
                fdlen = fact * length(poly);
                offsetj = (k-1)*fact;
                for l = 1:(tot / fdlen)
                    offset = (l-1)*fdlen+offsetj;
                    where = (1:fact)+offset;
                    expmono(where,j) = plen - k;
                    coefmono(where) = coefmono(where) * poly(k);
                end
            end
            fact = fdlen;
        end
        oexps = pout.bas2str(expmono);
        % walk through the output of this term, and populate/add-to the monomial poly
        for m = 1:tot
            okey = oexps(m,:);
            %                    if coefmono(m) == 0
            %                        continue
            %                    end
            if (pout.termMap.isKey(okey))
                pout.termMap(okey) = coefmono(m) + pout.termMap(okey);
            else
                pout.termMap(okey) = coefmono(m);
            end
        end
    end
    pout.calcWhich; % FIXME check if i need this
end % CONVERT
