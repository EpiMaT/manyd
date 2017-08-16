function p = uplus(pin)
    % Unary plus, just duplicate -- FIXME is this correct behavior?
    np = numel(pin);
    p(np) = manyd.tenspoly;
    for i = 1:np
        p(i) = pin(i).duplicate;
    end
    p = reshape(p, size(pin));
end
