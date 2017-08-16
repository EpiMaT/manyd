function p = plus(p1, p2)
   % Overloaded + operator to add tenspoly objects
   sp1 = size(p1);
   sp2 = size(p2);
   np1 = numel(p1);
   if isa(p1,'manyd.tenspoly') && isa(p2,'manyd.tenspoly')
       assert(isequal(sp1, sp2), 'Dimension mismatch.')
       assert(strcmp(p1.basis, p2.basis), 'Basis mismatch.')

       p(np1) = manyd.tenspoly; % Initialize basic object handle to set array class type
       for i = 1:np1
           p(i) = addtensorbases(p1(i), p2(i));
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
       error('Must add two tenspoly objects, or a scalar to a tenspoly.')
   end

   % Add scalar
   np = numel(pin);
   p(np) = manyd.tenspoly;
   for i = 1:np
       p(i) = addscalar(const, pin(i));
       calcWhich(p(i)); % adding a scalar adds a term. FIXME expensive
   end
   p = reshape(p, size(pin));
end
