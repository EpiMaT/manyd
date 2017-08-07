function output = pprint(p, vars)
    % Pretty print the output in terms of the basis functions
    % optional input of a cell vector of strings to use as var names
    strs = keys(p.termMap);
    slen = length(strs);
    assert(slen <= 100, 'Too many (>100) terms to pretty print.')
    ismono = strcmpi(p.basis,'mono');
    exps = p.str2bas(strs);
    if ~exist('vars', 'var')
        % default variable names of x1, x2, ...
        vars = cell(1,p.ndim);
        for i = 1:p.ndim
            vars{i} = ['x' int2str(i)];
        end
    end
    output = '';
    for i=1:slen
        key = strs{i};
        exp = exps(i,:);
        term = '';
        for j = 1:p.ndim
            if ismono
                if exp(j) > 1
                    term = [term ' ' vars{j} '^' num2str(exp(j))]; %#ok<AGROW>
                elseif exp(j) == 1
                    term = [term ' ' vars{j}]; %#ok<AGROW>
                end
            else
                term = [term ' b' num2str(exp(j)) '(' vars{j} ')']; %#ok<AGROW>
            end
        end
        coef = p.termMap(key);
        cstr = num2str(abs(coef));
        prestr = '';
        if abs(coef) == 1
            if i > 1 && coef == 1
                cstr = '';
            end
        else
            prestr = ' ';
        end
        if sign(coef) < 0
            prestr = ['-' prestr]; %#ok<AGROW>
            if i > 1
                prestr = [' ' prestr]; %#ok<AGROW>
            end
        else
            prestr = ['+' prestr]; %#ok<AGROW>
            if i > 1
                prestr = [' ' prestr]; %#ok<AGROW>
            else
                prestr = '';
                if coef == 1
                    term = term(2:end);
                end
            end
        end
        term = [prestr, cstr, term]; %#ok<AGROW>
        output = [output term]; %#ok<AGROW>
    end
end
