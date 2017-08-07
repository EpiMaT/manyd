function calcBasis(p)
    deg = p.ndeg;
    switch p.basis
        case 'mono'
            generate_monomial(p, deg)
        case 'leg'
            generate_legendre(p, deg)
        case 'leg01'
            generate_legendre(p, deg, [2 -1])
        otherwise
            error('Unknown basis');
    end
end
