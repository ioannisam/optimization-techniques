function mutated_pop = mutation(pop, params)

    [N, genes] = size(pop);
    mutated_pop = pop;
    
    rate  = params.mutation_rate;
    noise = params.mutation_noise;
    
    mask  = rand(N, genes) < rate;
    noise_matrix = randn(N, genes)*noise;
    mutated_pop(mask) = pop(mask) + noise_matrix(mask);
    
    mutated_pop(:, 1:5:end) = max(params.w_range(1), min(params.w_range(2), mutated_pop(:, 1:5:end)));
    mutated_pop(:, 2:5:end) = max(params.c1_range(1), min(params.c1_range(2), mutated_pop(:, 2:5:end)));
    mutated_pop(:, 3:5:end) = max(params.sigma_range(1), min(params.sigma_range(2), mutated_pop(:, 3:5:end)));
    mutated_pop(:, 4:5:end) = max(params.c2_range(1), min(params.c2_range(2), mutated_pop(:, 4:5:end)));
    mutated_pop(:, 5:5:end) = max(params.sigma_range(1), min(params.sigma_range(2), mutated_pop(:, 5:5:end)));
end