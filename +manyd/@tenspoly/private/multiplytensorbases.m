function p = multiplytensorbases(p1, p2)
    switch p1.basis
        case 'mono'
            p = multiplymono(p1, p2);
        case {'leg','leg01'}
            p = multiplylegendre(p1, p2);
    end
    p.simplify; % FIXME, slow to do both
    p.calcWhich;
end

function p = multiplymono(p1, p2)
    % Multiply two monomials together
    pdef.deg = p1.ndeg + p2.ndeg;
    pdef.basis = p1.basis;
    pdef.dim = p1.ndim;
    p = tpoly(pdef);
    str1 = keys(p1.termMap);
    str2 = keys(p2.termMap);
    for i = 1:length(str1)
        k1 = str1{i};
        for j = 1:length(str2)
            k2 = str2{j};
            k = char(k1+k2);
            v = 0;
            if p.termMap.isKey(k)
                v = p.termMap(k);
            end
            p.termMap(k) = v + p1.termMap(k1) * p2.termMap(k2);
        end
    end
end % MULTIPLYMONO

function p = multiplylegendre(p1, p2)
    % Multiply two Legendre basis polynomials together
    pdef.deg = p1.ndeg + p2.ndeg;
    pdef.basis = p1.basis;
    pdef.dim = p1.ndim;
    p = tpoly(pdef);
    str1 = keys(p1.termMap);
    str2 = keys(p2.termMap);

    % make all P_n(x)*P_m(x)'s and save the arrays of coefficients
    dd=max(p1.ndeg,p2.ndeg);
    mat = cell(dd+1);
    % FIXME: too many made
    for n = 0:dd
        for m = 0:n
            mat{n+1,m+1} = zeros(1,n+m+1);
            for r = 0:m
                mat{n+1,m+1}(n+m-2*r+1) = makeP(n,m,r);
            end
            mat{m+1,n+1} = mat{n+1,m+1};
        end
    end
    % loop through each term
    for i = 1:length(str1)
        for j = 1:length(str2)
            % for each term in p1 and p2
            s1 = str1{i};
            s2 = str2{j};
            c = p1.termMap(s1) * p2.termMap(s2);

            coefs = cell(1,pdef.dim); % init cell array for variable arrays of coeffs per dim
            ns = ones(pdef.dim,2);  % init total term count per dim
            for k = 1:pdef.dim
                d1 = double(s1(k));  % get sizes of each 1-d of the same dim
                d2 = double(s2(k));
                t = d1+d2+1;
                coefs{k} = mat{d1+1,d2+1};  % grab array of coeffs per dim
                ns((k+1):end,1) = ns((k+1):end,1) * t;
                ns(k,2) = t;
            end
            for id = 0:(prod(ns(:,2))-1)
                co = 1;
                div=fix(id ./ ns(:,1));
                bit=mod(div, ns(:,2))+1;
                for k = 1:pdef.dim
                    co = co * coefs{k}(bit(k));
                end
                key = p.bas2str(bit-1);
                v = 0;
                if p.termMap.isKey(key)
                    v = p.termMap(key);
                end
                p.termMap(key) = v + c * co;
            end
        end
    end
    
    function c = makeP(n,m,r)
        if n == 0 || m == 0
            c = 1;
            return
        end

        A  = [max(1,2*(m-r)-1), max(1,2*r-1), max(1,2*(n-r)-1), n+m-r, max(1,n+m-r-1)];
        B  = [(m-r), max(1,m-r-1), r, max(1,r-1), (n-r), max(1,n-r-1), max(1,2*(n+m-r)-1)];
        Ap = [2 max(0,n+m-r-1); (2*n + 2*m - 4*r + 1) 1];
        Bp = [2 max(0,m-r-1); 2 max(0,r-1); 2 max(0,n-r-1); (2*n + 2*m - 2*r + 1) 1];

        c = factorialratio(A,B,Ap,Bp);
    end
end % MULTIPLYLEGENDRE
