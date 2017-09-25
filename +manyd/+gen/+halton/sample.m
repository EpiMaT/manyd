function x_samp = sample(nx_samp, n_dim, seed)

    halton_dim_num_set ( n_dim );
    step = 0;
    halton_step_set ( step );
    seed_ndim(1:n_dim) = seed;  % FIXME, this is different seeding that we're used to!
    halton_seed_set ( seed_ndim );
    x_samp = halton_sequence (nx_samp)';

end
