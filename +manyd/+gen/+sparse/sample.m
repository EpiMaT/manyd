function x_samp = sample(n_dim, nx_samp)

    level=round(log2(nx_samp))+n_dim;
    [x_samp] = sparse_grid_cc(n_dim,level,nx_samp)' / 2 + 0.5;

end
