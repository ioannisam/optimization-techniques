function mutated_pop = mutation(pop, params)

    [N, genes] = size(pop);
    mutated_pop = pop;
    
    rate  = params.mutation_rate;
    noise = params.mutation_noise;
    
    mask  = rand(N, genes) < rate;
    noise = randn(N, genes)*noise;
    mutated_pop(mask) = pop(mask) + noise(mask);
    
    K = params.num_gaussians;
    for i = 1:K
        idx_base = (i-1)*5;
        idx_sig1 = idx_base + 3;
        idx_sig2 = idx_base + 5;
        
        mutated_pop(:, idx_sig1) = max(0.001, abs(mutated_pop(:, idx_sig1)));
        mutated_pop(:, idx_sig2) = max(0.001, abs(mutated_pop(:, idx_sig2)));
    end
end