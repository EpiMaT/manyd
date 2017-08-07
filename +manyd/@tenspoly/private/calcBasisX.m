function basis = calcBasisX(pin, x)
    % Walk polynomials, get ready to evaluate x points

    np = numel(pin);
    fns_union = cell(1, pin(1).ndim);
    for i = 1:np
        if i == 1
            ww = pin(i).basis;
        else
            assert(strcmp(pin(i).basis, ww));
        end
        for j = 1:pin(i).ndim
            fns_union{j} = [fns_union{j}, pin(i).whichFns{j}];
        end
    end
    for j = 1:pin(i).ndim
        fns_union{j} =unique(fns_union{j});
    end
    basis = calcXData(pin,x,fns_union);
end
