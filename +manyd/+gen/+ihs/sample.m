function x_samp = sample(nx_samp, n_dim, seed)

    duplication = 5;

    rnum2 = ihsJ (n_dim, nx_samp, duplication, seed);
    x_samp = (rnum2' - 0.5)/nx_samp ;

end
