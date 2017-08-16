function FR = factorialratio(A,B,Ap,Bp)
% ratio of factorial numbers
% (c) Jos van der Geest

% check the input arguments
narginchk(2,4)
if (~exist('Ap','var'))
    Ap = [1 1];
end
if (~exist('Bp','var'))
    Bp = [1 1];
end
if frcheck(A) || frcheck(B) || frcheck(Ap) || frcheck(Bp)
    error('Inputs should be numerical arrays with positive integers.')
end

% only values larger than 2 have an effect as both 1! and 0! equal 1
% we can subtract 1 if we do not forget to add 1 later
A = A(A>1) - 1;
B = B(B>1) - 1;
Ap = Ap(Ap(:,1)>1,:);
Ap(:,1) = Ap(:,1) - 1;
Bp = Bp(Bp(:,1)>1,:);
Bp(:,1) = Bp(:,1) - 1;

% what is the largest element?
maxE = max([A(:) ; B(:) ; 0 ; Ap(:,1) ; Bp(:,1)]);

if maxE > 0 && ~(isequal(A,B) && isequal(Ap,Bp)),
    % Create a 2 by m array holding the elements of A and B:
    % - the first column refers to the numerators of the ratio (A)
    % - the second column refers to the denominators of the ratio (B)
    R = sparse(A,1,1,maxE,2) + sparse(B,2,1,maxE,2);
    
    % By flipping, cumsumming (over columns) and flipping again ...
    R = flipud(cumsum(flipud(R)));
    % ... we get numbers that indicate how many times a factor is present in
    % the expanded ratio. R(X,1) indicates the number of times (X+1) is present in
    % the numerator in the expanded ratio, and R(X,2) the number of times
    % (X+1) is present in the denominator.

    % Addition: we can add in arbitrary powers here, such as 2^5 in the denominator
    [r,~]=size(Ap);
    for i=1:r
        w = Ap(i,1);
        R(w,1) = R(w,1) + Ap(i,2);
    end
    [r,~]=size(Bp);
    for i=1:r
        w = Bp(i,1);
        R(w,2) = R(w,2) + Bp(i,2);
    end
    % The difference will give us the exponent for taking the power of the value (X+1).
    R = (R(:,1) - R(:,2)).';    % exponents
    X = 2:(maxE+1) ;            % base numbers (we now do need to add the 1)
    % We only used the nonzero entries, since X^0 = 1, and this may affect
    % the time used for ...
    q = find(R);
    % ... getting the total product
    FR = prod(X(q).^R(q));
else
    % All elements were less than 2, or A equals B
    FR = 1;
end
return % return w/ FR

    function t=frcheck(A)
        t = isempty(A) || ~isnumeric(A) || any(A(:)<0) || any(fix(A(:)) ~= A(:));
    end
end % FACTORIALRATIO