function x_samp = function sample(nx_samp, n_dim, seed)

    rng(seed);
    x_seed = rand(1,n_dim) ;
    [x_samp] = sample_gen_fith(nx_samp, n_dim, x_seed) ;

end
