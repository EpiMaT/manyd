function x_samp = function sample(n_dim, nx_samp, seed)

    rng(seed);
    x_seed = rand(1,n_dim) ;
    [x_samp] = sample_gen_fith_yc(nx_samp,n_dim,x_seed,param.orig) ;

end
