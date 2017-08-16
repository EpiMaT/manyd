classdef tenspoly < handle
    % TENSPOLY  Multi-dimensional polynomial via tensoring 1-D polynomials
    %
    %   A tenspoly object represents a tensored product of 1-D basis
    %   functions.  This class overrides MATLAB operators such as plus and
    %   times to allow for easy vector-wise addition and multiplication of
    %   tenspoly objects that are in the same basis.
    %
    %   This class also provides other functionality on the function
    %   such as:
    %     * evaluation
    %     * derivatives
    %     * integrate - definite integrals
    %     * convert - conversion between (some) bases,
    %
    %   Current basis types are Legendre 'leg', shifted Legendre 'leg01',
    %   Monomial 'mono'.
    properties
        basis = 'empty' % Options: 'leg', 'leg01', 'mono'.  'empty' used for obj array construction
        ndeg = 0        % maximum index of the basis functions
        ndim = 1        % number of dimensions/variables
    end
    properties (Access=public)
        termMap  % hashmap of string representation of term to its coefficient
        basisFns % cell array of 1d functions
        whichFns % cell array that keeps track of which bases fns are in use
    end
    %% Constructor
    methods
        function p = tenspoly(a)
            % tenspoly  Construct a tenspoly object
            if ~exist('a','var')
                % Return a very empty, basic basis function
                % This has an 'empty' basis and will complain if used like a fully constructed object
                % I only envision this being used to construct struct arrays.
                p.termMap = containers.Map;
                return
            end

            if isa(a, 'manyd.tenspoly')
                % Duplicate all data from given tenspoly object
                p.basis    = a.basis;
                p.basisFns = a.basisFns;
                p.ndim     = a.ndim;
                p.ndeg     = a.ndeg;
                p.whichFns = a.whichFns;
                
                if (a.termMap.Count > 0)
                    % FIXME is there a better way to duplicate a containers.Map?
                    p.termMap = containers.Map(keys(a.termMap),values(a.termMap));
                else
                    p.termMap = containers.Map;
                end
            elseif isa(a, 'struct')
                % This is the main way to define the desired tensored basis.
                %   Common usage:
                %     pdef.basis  = 'leg01'
                %     pdef.dim   = 6
                %     pdef.deg   = 6
                %     p = tenspoly(pdef)
                assert(isfield(a,'basis') && ischar(a.basis), ...
                    'Field .basis defines the type of basis function')

                % Either field 'rank' or 'deg' tell us which basis functions to use
                if isfield(a,'rank')
                    ideg = a.rank;
                elseif isfield(a,'deg')
                    ideg = a.deg;
                else
                    ideg = 0;
                end

                if isscalar(ideg) && isnumeric(ideg)
                    % If given only a number, we explicitly need ndim.

                    assert(isfield(a,'dim') && fix(a.dim) == a.dim && a.dim >= 1, ...
                        'Field .dim is a non-negative integer defining how many dimensions');
                    idim = a.dim;
                    maxdeg = ideg;
                    nterms = nchoosek(maxdeg + idim, idim);
                    if nterms > 100000
                        error('Number of terms exceeds 100000!  Aborting construction.')
                    end
                    terms = NaN(nterms, idim);
                    pattern = zeros(1, idim);
                    terms(1,:) = pattern;
                    idx = 2;
                    % now construct the non-zero exponents
                    % FIXME: done via grevlex, wasteful but already done
                    for current_sum = 1:maxdeg
                        pattern(1) = current_sum;
                        terms(idx,:) = pattern;
                        idx = idx + 1;
                        while pattern(end) < current_sum
                            for i = 1:idim
                                if 0 < pattern(idim - i)
                                    pattern(idim - i) = pattern(idim - i) - 1;
                                    if 1 < i
                                        pattern(idim - i + 1) = 1 + pattern(end);
                                        pattern(end) = 0;
                                    else
                                        pattern(end) = pattern(end) + 1;
                                    end
                                    break
                                end
                            end
                            terms(idx,:) = pattern;
                            idx = idx + 1;
                        end
                        pattern(end) = 0;
                    end
                    % For scalar full rank triangular, every dim gets every degree
                    for dim = 1:idim
                        p.whichFns{dim} = 0:maxdeg;
                    end

                elseif iscell(ideg)
                    % if a cell array, each entry is a vector defining which basis functions to tensor together
                    % assume length of ideg is ndim, and compare with field .dim if given
                    idim = length(ideg);
                    assert(~isfield(a,'dim') || a.dim == idim, ...
                        'Field .dim does not match with .deg/.rank description');

                    p.whichFns = cell(1,idim);
                    maxdeg = 0;
                    nterms = 1;
                    for i = 1:idim
                        % each dimension can be an array of values
                        % an empty cell is a 0
                        dims = ideg{i};
                        maxdeg = max(maxdeg, max(dims));
                        dlen = length(dims);
                        nterms = nterms * max(1, dlen);
                        % push each into p.whichFns
                        p.whichFns{i} = dims;
                    end
                    if nterms > 100000
                        error('Number of terms exceeds 100000!  Aborting construction.')
                    end
                    % construct each term
                    terms = NaN(nterms, idim);
                    fact = 1;
                    for i = idim:-1:1
                        dims = p.whichFns{i};
                        dlen = length(dims);
                        for j = 1:dlen
                            fdlen = fact*dlen;
                            chunk = zeros(fact,1)+dims(j);
                            offsetj = (j-1)*fact;
                            for k = 1:(nterms / fdlen)
                                offset = (k-1)*fdlen+offsetj;
                                terms((1:fact)+offset,i) = chunk;
                            end
                        end
                        fact = fdlen;
                    end
                elseif ~isscalar(ideg)
                    % Or maybe it's a full exponent matrix of desired terms
                    terms = ideg;
                    maxdeg = max(max(terms));
                    [nterms, idim] = size(terms);
                    % Check for .dim agreement, if specified
                    assert(~isfield(a,'dim') || a.dim == idim, ...
                        'Field .dim does not match with .deg/.rank description');

                    p.whichFns = cell(1,idim);
                    for i = 1:idim
                        p.whichFns{i} = unique(terms(:,i));
                    end
                else
                    error('Unknown Inputs?')
                end
                % if 'coef' exists, it fully defines the coefficients, or is a scalar for all
                if isfield(a,'coef')
                    coef = a.coef;
                    assert(isscalar(coef) || nterms == length(coef), ...
                        'Field .coef either must be same length as the number of terms, or a scalar.')
                    assert(isnumeric(coef))
                else
                    coef = 0;
                end

                % Convert basis matrix to keys and populate termMap
                p.termMap = containers.Map('keyType','char','valueType','double');
                strs = p.bas2str(terms);
                if isscalar(coef)
                    for i = 1:size(strs,1)
                        p.termMap(strs(i,:)) = coef;
                    end
                else
                    assert(length(coef) == nterms);
                    for i = 1:size(strs,1)
                        p.termMap(strs(i,:)) = coef(i);
                    end
                end
                % generate basisFns
                p.ndeg = maxdeg;
                p.basis = a.basis;
                p.ndim = idim;
                calcBasis(p);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Static Methods
    methods (Static, Access=private)

        function exps = str2bas(strs)
            % Convert char array of exponent (hash key) to matrix of ints
            if iscell(strs)
                slen = numel(strs);
                strs = cell2mat(reshape(strs,slen,1));
            end
            exps = double(strs);
            return
        end % STR2BAS

        function strs = bas2str(terms)
            % Convert matrix of exponents to char array (hash key)
            strs = char(terms);
            return
        end % BAS2STR

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Sample Methods
    methods
        function pout = duplicate(p)
            % Use the constructor and return a duplicate of the tenspoly object
            pout = manyd.tenspoly(p);
        end % DUPLICATE
    end

end
