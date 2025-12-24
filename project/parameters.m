% Parameters
params.num_samples = 1000;

params.c1_range = [-1, 2];
params.c2_range = [-2, 1];
params.w_range = [-10, 10];
params.sigma_range = [0.2, 2.0]; 

% Hyperparameters
params.pop_size = 100;          
params.num_gaussians = 6;
params.max_generations = 3000;

params.crossover_rate = 0.6;
params.mutation_rate = 0.1;
params.mutation_noise = 0.05;
params.pruning_threshold = 0.6;