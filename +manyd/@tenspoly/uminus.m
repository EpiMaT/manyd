function p = uminus(pin)
    % Unary minus
    np = numel(pin);
    p(np) = tpoly;
    for i = 1:np
        p(i) = multiplyscalar(-1, pin(i));
    end
    p = reshape(p, size(pin));
end
