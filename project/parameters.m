% Problem Constraints
params.num_samples = 1000;

params.c1_range = [-1, 2];
params.c2_range = [-2, 1];
params.w_range = [-10, 10];
params.sigma_range = [0.1, 3.0]; 

% Hyperparameters
params.pop_size = 100;          
params.num_gaussians = 15;
params.max_generations = 1000;

params.tournament_size = 3;
params.crossover_rate = 0.8;
params.mutation_rate = 0.05;
params.mutation_noise = 0.1;