function p = minus(p1, p2)
    import manyd.tenspoly
    % Overloaded - operator to subtract tenspoly objects
    sp1 = size(p1);
    sp2 = size(p2);
    np1 = numel(p1);
    if isa(p1,'manyd.tenspoly') && isa(p2,'manyd.tenspoly')
        assert(isequal(sp1, sp2), 'Dimension mismatch.')
        assert(strcmp(p1.basis, p2.basis), 'Basis mismatch.')
        p(np1) = tenspoly; % Initialize basic object handle to set array class type
        for i = 1:np1
            p(i) = subtracttensorbases(p1(i), p2(i));
        end
        p = reshape(p, sp1);
        return
    end
    % Find which input is the scalar or error if none are.
    if isscalar(p1) && isnumeric(p1)
        pin = p2;
    elseif isscalar(p2) && isnumeric(p2)
        pin = p1;
    else
        error('Must subtract two tenspoly objects, or a scalar and a tenspoly.')
    end
    % Subtract scalar (but, use generic func)
    np = numel(pin);
    p(np) = tenspoly;
    for i = 1:np
        p(i) = subtracttensorbases(p1, p2);
    end
    p = reshape(p, size(pin));
end
