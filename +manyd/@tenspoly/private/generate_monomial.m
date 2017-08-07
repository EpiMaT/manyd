function generate_monomial(p, ndeg)
    % Populate the basis with monomial polys
    for i = 1:(ndeg+1)
        n = zeros(1,i);
        n(1) = 1;
        p.basisFns{i} = n;
    end
end
