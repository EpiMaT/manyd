function x_samp = sample(n_dim, nx_samp, seed)

    [ rnum2, seed_new ] = niederreiterJ_generate ( n_dim, nx_samp, seed );
    x_samp = rnum2';
end
