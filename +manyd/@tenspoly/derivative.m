function pder = derivative(p, idx)
    % Returns a new tpoly object that is the derivative in the given dimension
    if exist('idx','var')
        assert(idx >= 1 && idx <= p.ndim);
    else
        assert(p.ndim ~= 1, 'Must select the dimension on which to take the derivative.');
        idx = 1;
    end
    exps = p.str2bas(keys(p.termMap));
    vals = cell2mat(values(p.termMap))';
    switch p.basis
        case 'mono'
            expsder = exps;
            expsder(:,idx) = exps(:,idx) - 1; % subtract 1 from each power
            tidxs = find(expsder(:,idx) >= 0); % find terms that survived
            expsder = expsder(tidxs,:);
            valsder = vals(tidxs) .* exps(tidxs,idx);

            pdef.basis = p.basis;
            pdef.dim = p.ndim;
            pdef.deg = expsder;
            pdef.coef = valsder;
            pder = tpoly(pdef); % create derivative poly
        case 'leg'
        case 'leg01'
            if strcmp(p.basis, 'leg01')
                c = 2;
            else
                c = 1;
            end
            pdef.basis = p.basis;
            pdef.deg  = p.ndeg;
            pdef.dim  = p.ndim;
            pder = tpoly(pdef);
            nterms = p.termMap.Count;
            for i = 1:nterms
                which = exps(i,idx);
                if which <= 0
                    continue
                end
                exp = exps(i,:);
                val = vals(i);
                for j = which:-2:1
                    coef = c * (2*j - 1);
                    wexp = exp;
                    wexp(idx) = j-1;
                    okey = pder.bas2str(wexp);
                    if (pder.termMap.isKey(okey))
                        pder.termMap(okey) = coef * val + pder.termMap(okey);
                    else
                        pder.termMap(okey) = coef * val;
                    end
                end
            end
        otherwise
            error('Unknown basis')
    end
    calcWhich(pder);
end
