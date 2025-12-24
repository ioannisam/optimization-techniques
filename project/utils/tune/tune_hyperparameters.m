clear; clc; close all;

thisDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(thisDir));

addpath(rootDir);
addpath(fullfile(rootDir, 'utils'));
addpath(fullfile(rootDir, 'src'));
addpath(fullfile(rootDir, 'src', 'helpers'));

parameters;

params.num_gaussians = 6; 
params.max_generations = 1000; 

crossover_grid = [0.6, 0.8, 0.9];     
mutation_grid  = [0.01, 0.05, 0.10];  
noise_grid     = [0.05, 0.10, 0.20];  

fprintf('Generating fixed datasets...\n');
[U_train, Y_train] = generate_data(params.num_samples);
[U_val, Y_val]     = generate_data(params.num_samples);

best_mse = inf;
best_combo = [];
results_log = []; 

total_combinations = length(crossover_grid) * length(mutation_grid) * length(noise_grid);
current_run = 0;

fprintf('Starting Grid Search over %d combinations...\n', total_combinations);
fprintf('----------------------------------------------------------------\n');
fprintf('| %-5s | %-5s | %-5s | %-10s | %-10s |\n', 'Cross', 'Mut', 'Noise', 'Val MSE', 'Status');
fprintf('----------------------------------------------------------------\n');

timerTotal = tic;
for c_rate = crossover_grid
    for m_rate = mutation_grid
        for m_noise = noise_grid
            
            current_run = current_run + 1;
            
            params.crossover_rate = c_rate;
            params.mutation_rate  = m_rate;
            params.mutation_noise = m_noise;
            
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
            
            fprintf('| %5.2f | %5.2f | %5.2f | %10.5f |', c_rate, m_rate, m_noise, val_mse);
            
            if val_mse < best_mse
                best_mse = val_mse;
                best_combo = params;
                fprintf('  <-- NEW BEST\n');
            else
                fprintf('\n');
            end
            
            results_log = [results_log; c_rate, m_rate, m_noise, val_mse];
        end
    end
end

toc(timerTotal);

fprintf('\nOPTIMIZATION COMPLETE\n');
fprintf('Best Validation MSE: %.5f\n', best_mse);
fprintf('   params.crossover_rate = %.2f;\n', best_combo.crossover_rate);
fprintf('   params.mutation_rate  = %.2f;\n', best_combo.mutation_rate);
fprintf('   params.mutation_noise = %.2f;\n', best_combo.mutation_noise);

unique_c = unique(results_log(:,1));
unique_m = unique(results_log(:,2));
mse_matrix = zeros(length(unique_c), length(unique_m));

for i = 1:length(unique_c)
    for j = 1:length(unique_m)
        mask = (results_log(:,1) == unique_c(i)) & (results_log(:,2) == unique_m(j));
        mse_matrix(i,j) = mean(results_log(mask, 4));
    end
end

figure;
heatmap(unique_m, unique_c, mse_matrix, ...
    'Colormap', parula, 'ColorLimits', [min(results_log(:,4)), median(results_log(:,4))]);
xlabel('Mutation Rate');
ylabel('Crossover Rate');
title('Average MSE (Lower is Better)');

save_figures();