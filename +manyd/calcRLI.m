
function [p, debug] = calcRLI(tp, xdata, fdata, weights, options)
% calcRLI  Calculate the Regularized Linear Inverse
% options.{init_coef, epsilon, max_iter, tol_conv, tol_coef, full_debug}
% options.regularizer.{normalizer, lambda, lpnorm}
%     normalizer: 'norm', 'norm nterms', 'norm nterms fast', 'residual'
%     lambda: tuning parameter, domain of [0,1]
%     lpnorm: regularizer norm

% basic assertions
flen = length(fdata);
[xpts, xdim] = size(xdata);
assert(xpts == flen);
% check for various options
if isfield(options,'full_debug')
    fulldebug = options.full_debug;
else
    fulldebug = 0;
end
if isfield(options,'epsilon')
    eps = options.epsilon;
    assert(eps > 0);
else
    eps = 1e-8;
end
if isfield(options,'tol_conv')
    tol_conv = options.tol_conv;
    assert(tol_conv > 0);
else
    tol_conv = 1e-3;
end
if isfield(options,'tol_coef')
    tol_coef = options.tol_coef;
    assert(tol_coef >= 0);
else
    tol_coef = 0;
end
if isfield(options,'max_iter')
    maxIter = options.max_iter;
    assert(maxIter > 0);
else
    maxIter = 100;
end
if ~isfield(options,'regularizer')
    options.regularizer.normalizer = '';
end

% if isfield(options,'full_basis')
%     pbasis = options.full_basis;
% else
%     pbasis = calcBasisX(pin, xdata);
% end

p = tp;
% np = numel(pin);
% for i=1:np % for each tensorbasis object FIXME.  this select few uses for multiple input ps!
%     p = pin(i);
    assert(p.ndim == xdim);
    
    nterms = p.nterms; % convert int to double
    if isfield(options,'init_coef')
        initCoef = options.init_coef;
        assert(length(initCoef) == nterms);
    else
        initCoef = zeros(nterms,1);
    end
    % calculate vandermonde matrix
    A = calcDesignMatrix(p, xdata);%, pbasis);
    
    % if only 1 term
    if size(A,2)==1
        if isfield(options.regularizer, 'lambda') && options.regularizer.lambda ~= 0
            warning('Setting lambda to 0')
        end
        options.regularizer.lambda=0;
    end
    % calculate the Weighted Normal matrix
    if isscalar(weights)
        weights = zeros(flen,1) + weights;
    else
        assert(length(weights) == flen);
    end
    w = diag(sqrt(weights));
    wA = w*A;
    AWf = wA'*w*fdata;
    AtWA = wA'*wA;
    
    if isfield(options.regularizer, 'lambda')
        lambda = options.regularizer.lambda;
        assert(lambda >= 0 && lambda <= 1)
    else
        lambda = 0;
    end
    if lambda == 0
        options.regularizer.normalizer = 'none';
        options.solver = 'WLS';
    end
    
    if isfield(options.regularizer, 'lpnorm')
        lpnorm = options.regularizer.lpnorm;
        assert(lpnorm >= 0 && lpnorm <= 3);
    else
        lpnorm = 1;
    end
    % FIXME - probably a better way to deal w/ all these options
    if lpnorm==2
        orn = options.regularizer.normalizer;
        assert(strcmpi(orn,'none') || strcmpi(orn,'norm'));
        assert(strcmp(options.solver,'WLS'));
    end
    assert(lambda > 0 || nterms <= flen, ...
        'Either allow compression (lambda = %.2f > 0, or # terms more than # pts: %d <= %d', ...
        lambda, nterms, flen)
    % FIXME - probably a better way to deal w/ all these options
    if isfield(options, 'coefweight') && lambda > 0
        coefweight = options.coefweight;
        assert(isnumeric(coefweight) && (length(coefweight) == nterms || length(coefweight) == 1))
    else
        coefweight = 1;
    end
    
    % Set mu1 and mu2 for iterative solvers
    switch options.regularizer.normalizer
        case 'none'
            mu1=(1-lambda);
            mu2=lambda;
        case 'norm'
            ftf = dot(fdata,fdata);
            mu1 = (1-lambda) / ftf;
            mu2 = sqrt(norm(A'*A)/ftf) * lambda;
        case 'norm nterms'
            ftf = dot(fdata,fdata);
            mu1 = (1-lambda) / ftf;
            mu2 = sqrt(norm(A'*A)/ftf) * lambda / nterms;
        case 'norm nterms fast'
            ftf = dot(fdata,fdata);
            mu1 = (1-lambda) / ftf;
            mu2base = sqrt(norm(A'*A)/ftf) * lambda;
            mu2 = mu2base / nterms;
        case 'residual'
            initCoef = A'*fdata; % only works for non FISTA (i forget why :( )
            % calculates mu1, mu2 in loop
    end
    
    % Initializations for specific solvers
    switch options.solver
        case 'FISTA'
            L = norm(AtWA); % the lipschitz constant
            xp = initCoef;
            yc = initCoef;
            tc = 1;
            coef = initCoef; % FIXME, duplicate xc
        otherwise
            coef = initCoef;
    end
    % Main loop
    idxs = 1:nterms; % only FIRLS really uses this, FIXME?
    iter = 0;
    dx = realmax; % convergence gap
    while iter < maxIter && dx > tol_conv
        % Some regularizers set mu1 and mu2 every time step
        switch options.regularizer.normalizer
            case 'norm nterms fast'
                mu2 = mu2base / length(idxs);
            case 'residual'
                %                         Rp = .5*sumsqr(A(:,idxs) * coef(idxs) - fdata);
                temp_resid = A(:,idxs) * coef(idxs) - fdata;
                Rp = .5 * (temp_resid)' * temp_resid;
                Rc = sum(abs(coef).^lpnorm);
                e = eps * max(Rc, Rp);
                mu1 = max(Rc, e) * (1-lambda);
                mu2 = max(Rp, e) * lambda;
        end
        % Iteratively solve Regularized Least Squares
        switch options.solver
            case 'WLS'
                lambda = mu2/mu1;
                if (lpnorm == 2)
                    AtWA=AtWA*2*(mu2/mu1)*diag(coefweight);
                end
                coef = AtWA \ AWf;
                maxIter = 1;
            case 'IRLS'
                clast = coef;
                
                B1 = mu1 * AtWA;
                if lpnorm == 2
                    B2 = mu2 * diag((coefweight.*lpnorm)./max(eps, abs(coef)));
                else
                    B2 = mu2 * diag((coefweight.*lpnorm)./max(eps, (coef.^2).^(1-lpnorm/2)));
                end
                b = mu1 * AWf;
                coef = (B1+B2)\b;
                
                dx = norm(coef-clast)/(norm(clast)+eps);
            case 'FIRLS'
                clast = coef;
                
                c = coef(idxs);
                cweight=coefweight(idxs);
                wA = w * A(:,idxs);
                AWf = wA' * w * fdata;
                AtWA = wA' * wA;
                
                B1 = mu1 * AtWA;
                B2 = mu2 * diag((cweight.*lpnorm)./max(eps, (c.^2).^(1-lpnorm/2)));
                b = mu1 * AWf;
                coef(idxs) = (B1+B2)\b;
                
                dx = norm(coef(idxs)-clast(idxs))/(norm(clast(idxs))+eps);
                idxs = find(abs(coef) > tol_coef);
            case 'FISTA'
                lambda = mu2/mu1;
                temp = yc-wA'*(wA*yc-w*fdata)/L;
                xc = sign(temp) .* max(0, abs(temp) - lambda.*coefweight./L); % Soft threshold
                tn = (1 + sqrt(1 + 4*tc^2)) / 2;
                yn = xc + (tc-1)*(xc - xp) / tn;
                dx = norm(xc-xp)/(norm(xc)+eps);
                
                xp=xc; % update x_previous
                yc=yn; % update y_current
                tc=tn; % update t_current
                coef = xc; % FIXME, rename xc, etc, coef is duplicate
            otherwise
                error('Unknown solver')
        end
        iter = iter+1;
        if fulldebug
            debug.iter = [debug.iter, iter];
            debug.nterms = [debug.nterms, length(idxs)];
            debug.dx = [debug.dx, dx];
            if ~strcmpi(options.solver, 'WLS')
                debug.mu1 = [debug.mu1, mu1];
                debug.mu2 = [debug.mu2, mu2];
            end
        end
    end
    % set coefficients
    p.setCoefficients(coef);

    % if we were merely tolerant of outcome, simplify output now
    % FIXME - probably a better way to deal with all these options
    if isfield(options,'tol_coef') && (strcmpi(options.solver,'IRLS') || strcmpi(options.solver,'FIRLS'))
        p.simplify(tol_coef);
    end
    if ~fulldebug
        debug.iter = iter;
        debug.dx = dx;
        debug.tol_conv = tol_conv;
        if ~strcmpi(options.solver, 'WLS')
            debug.mu1 = mu1;
            debug.mu2 = mu2;
        end
    end
% end
end % CALCREGULARIZEDLINEARINVERSE