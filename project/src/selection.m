function parents = selection(pop, fitness, params)

    N = params.pop_size;
    [~, genes] = size(pop);

    % scale to counteract roulette selection drawbacks
    f_min = min(fitness);
    f_max = max(fitness);
    if (f_max - f_min) < 1e-6
        scaled_fitness = ones(size(fitness));
    else
        scaled_fitness = (fitness-f_min) ./ (f_max-f_min) + eps;
    end

    total_fitness = sum(scaled_fitness);
    probs = scaled_fitness / total_fitness;
    cum_probs = cumsum(probs);

    parents = zeros(N, genes);
    for i = 1:N
        r = rand();
        selected_idx = find(cum_probs >= r, 1);
        
        % prevent float error
        if isempty(selected_idx)
            selected_idx = N;
        end
        
        parents(i, :) = pop(selected_idx, :);
    end
end