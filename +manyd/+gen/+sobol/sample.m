function x_samp = sobol(n_dim, nx_samp, seed)

    if floor(log2(nx_samp))~=log2(nx_samp)
        warning('num samples really should be a power of 2')
    end
    rnum2 = i4_sobol_generate (n_dim, nx_samp, seed );
    x_samp=rnum2';

end
