function pop = initialize_population(params)

    N = params.pop_size;
    K = params.num_gaussians;
    num_genes = 5*K;
    
    w_min = params.w_range(1); w_max = params.w_range(2);
    c1_min = params.c1_range(1); c1_max = params.c1_range(2);
    c2_min = params.c2_range(1); c2_max = params.c2_range(2);
    s_min = params.sigma_range(1); s_max = params.sigma_range(2);

    pop = zeros(N, num_genes);
    for i = 1:K
        idx = (i-1)*5;
        
        pop(:, idx+1) = (w_max  - w_min)  * rand(N, 1) + w_min;
        pop(:, idx+2) = (c1_max - c1_min) * rand(N, 1) + c1_min;
        pop(:, idx+3) = (s_max  - s_min)  * rand(N, 1) + s_min;
        pop(:, idx+4) = (c2_max - c2_min) * rand(N, 1) + c2_min;
        pop(:, idx+5) = (s_max  - s_min)  * rand(N, 1) + s_min;
    end
end