function basic

import manyd.*

params = [1500 3500;
          1500 3500];
% params = [1000 2000;
%            500 1000];

[ndim, ~] = size(params);

npts = 30;

pts = sample_gen(npts,ndim,'ihs');
scaled_pts = scale(pts, params);

natts = 2;
time_data = zeros(npts,natts);
for i = 1:npts
    bb = make_blackbox(round(scaled_pts(i,:)));
    for j = 1:natts
        t_ = tic;
        bb();
        time_data(i,j) = toc(t_);
    end
end
t_val = time_data(:,2)*1000;
% t_sdv = std(time_data,1,2);

pdef.dim = ndim;
pdef.deg = {0:2,0:2}; % FIXME! hardcoded 2-D
pdef.basis = 'mono';

tp = tenspoly(pdef);

A = tp.calcDesignMatrix(scaled_pts);
b = t_val;

terms = tp.terms();

wls_coef = A\b;
[~, wls_idx] = sort(abs(wls_coef),1,'descend');
% tp.setCoefficients(wls_coef);
% tp.pprint

% [lasso_coeff, fit]=lasso(A,b,'CV',10);

% mse_coef = lasso_coeff(:,fit.IndexMinMSE);
% [~, mse_idx] = sort(abs(mse_coef),1,'descend');
% tp.setCoefficients(mse_coef);
% tp.simplify.pprint


% se1_coef = lasso_coeff(:,fit.Index1SE);
% [~, se1_idx] = sort(abs(se1_coef),1,'descend');

% tp.setCoefficients(lasso_coeff(:,fit.Index1SE));
% tp.simplify.pprint
which = 1:7;

Wcoef = wls_coef(wls_idx(which));
% Mcoef = mse_coef(mse_idx(which));
% Scoef = se1_coef(se1_idx(which));

Wexps = terms(wls_idx(which),:);
% Mexps = terms(mse_idx(which),:);
% Sexps = terms(se1_idx(which),:);

table(Wcoef,Wexps)%,Mcoef,Mexps,Scoef,Sexps)

figure
mins = min(scaled_pts);
maxs = max(scaled_pts);
ng = 30;
[xi,yi] = meshgrid(linspace(mins(1),maxs(1),ng),linspace(mins(2),maxs(2),ng));
zi = griddata(scaled_pts(:,1),scaled_pts(:,2),t_val,xi,yi);
contour(xi,yi,zi);
xlabel('Rows')
ylabel('Cols')
colorbar
axis square

% figure
% scatter3(scaled_pts(:,1),scaled_pts(:,2),t_sdv)
% xlabel('Rows')
% ylabel('Cols')

end

function new_pts = scale(pts, ranges)
    low = ranges(:,1);
    high = ranges(:,2);

    range = high - low;

    new_pts = bsxfun(@plus, bsxfun(@times, pts, range'), low');
end

function bb = make_blackbox(params)
row = params(1);
col = params(2);

A = rand(row, col);
b = rand(row, 1);

bb = @() A\b;
end
