clear; clc; close all;

thisDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(thisDir));

addpath(rootDir);
addpath(fullfile(rootDir, 'utils'));
addpath(fullfile(rootDir, 'src'));
addpath(fullfile(rootDir, 'src', 'helpers'));

parameters; 

k_min = 2;              
k_max = 12;             
params.max_generations = 1000;

fprintf('Generating fixed datasets for fair comparison...\n');
[U_train, Y_train] = generate_data(params.num_samples);
[U_val, Y_val]     = generate_data(params.num_samples);

results = [];

fprintf('Starting search for optimal K (Range: %d-%d)...\n', k_min, k_max);
for k = k_min:k_max
    
    fprintf('\nTesting K = %d Gaussians... ', k);
    params.num_gaussians = k;
    
    pop = initialize_population(params);
    [fitness_score, mse] = fitness(pop, U_train, Y_train, params);
    
    for gen = 1:params.max_generations
        [~, best_idx] = max(fitness_score);
        elite_ind = pop(best_idx, :);
        
        parents = selection(pop, fitness_score, params);
        offspring = crossover(parents, params);
        new_pop = mutation(offspring, params);
        new_pop(1, :) = elite_ind;
        
        [new_fit, new_mse] = fitness(new_pop, U_train, Y_train, params);
        pop = new_pop;
        fitness_score = new_fit;
    end
    
    [~, best_idx] = max(fitness_score);
    best_sol = pop(best_idx, :);
    val_params = params; val_params.pop_size = 1;
    [~, val_mse] = fitness(best_sol, U_val, Y_val, val_params);
    
    [~, active_count] = prune(best_sol, params);
    
    fprintf('Done. | Val MSE: %.5f | Active Terms: %d', val_mse, active_count);
    results = [results; k, val_mse, active_count];
end

figure('Name', 'Optimization of K');

yyaxis left
plot(results(:,1), results(:,2), '-bo', 'LineWidth', 2, 'MarkerFaceColor', 'b');
xlabel('Number of Gaussians (K)');
ylabel('Validation MSE (Lower is Better)');
title('Model Complexity Analysis: MSE vs. K');
grid on;

yyaxis right
plot(results(:,1), results(:,3), '--rx', 'LineWidth', 1.5);
ylabel('Active Terms after Pruning');
ylim([0, k_max+1]);
legend('Validation MSE', 'Active Terms');

[min_mse, idx] = min(results(:,2));
best_k = results(idx, 1);
fprintf('\n\n--- RESULTS SUMMARY ---\n');
fprintf('Minimum Error found at K = %d (MSE: %.5f)\n', best_k, min_mse);

save_figures();