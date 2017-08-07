function p = times(p1, p2)
    % Overloaded .* operator to multiply tpoly objects

    sp1 = size(p1);
    sp2 = size(p2);
    np1 = numel(p1);
    if isa(p1,'tpoly') && isa(p2,'tpoly')
        assert(isequal(sp1, sp2), 'Dimension mismatch.')
        assert(strcmp(p1.basis, p2.basis), 'Basis mismatch.')
        p(np1) = tpoly; % Initialize basic object handle to set array class type
        for i = 1:np1
            p(i) = multiplytensorbases(p1(i), p2(i));
        end
        p = reshape(p, sp1);
        return
    end

    % Find which input is the scalar or error if none are.
    if isscalar(p1) && isnumeric(p1)
        const = p1;
        pin = p2;
    elseif isscalar(p2) && isnumeric(p2)
        const = p2;
        pin = p1;
    else
        error('Must multiply two tpoly objects, or a scalar to a tpoly.')
    end

    % Multiply scalar
    np = numel(pin);
    p(np) = tpoly;
    for i = 1:np
        p(i) = multiplyscalar(const, pin(i));
    end
    p = reshape(p, size(pin));
end
