function generate_legendre(p, ndeg, shift)
    % Populates the basis with Legendre polys
    %   Legendre is defined on [-1 1], can shift the domain
    if ~exist('shift', 'var')
        shift = [1 0]; %Default domain [-1, 1] has `x` as p1
    end
    % init
    p.basisFns{1} = 1;     n2 = p.basisFns{1};
    p.basisFns{2} = shift; n1 = p.basisFns{2};
    for i = 3:(ndeg+1)
        j = i-1;
        % P_{n} = (2j-1) * x * P_{n-1}
        n0 = (2*j-1) * conv(shift,n1);
        k = length(n0) - length(n2) + 1; % FIXME maybe simplify?
        % P_{n} = P_{n} - (j-1) * P_{n-2}
        n0(k:end) = n0(k:end) - (j-1) * n2;
        % P_{n} = P_{n} / j
        n0 = n0 ./ j;
        p.basisFns{i} = n0;
        n2 = n1; n1 = n0; %increment
    end
end
