function x_samp = sample(nx_samp, n_dim, seed, orig_pts)

    rng(seed);
    x_seed = rand(1,n_dim) ;
    [x_samp] = sample_gen_fith_yc(nx_samp, n_dim, x_seed, orig_pts) ;

end