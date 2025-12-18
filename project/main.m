clear; clc; close all;

addpath('src');
addpath('utils');
parameters;

[U, Y] = generate_data(params.num_samples);
params.c1_range = [min(U(:,1)), max(U(:,1))];
params.c2_range = [min(U(:,2)), max(U(:,2))];

fprintf('Initializing population...\n');
pop = initialize_population(params);

[fitness_score, mse] = fitness(pop, U, Y, params);
best_mse_history = zeros(params.max_generations, 1);

fprintf('Starting Genetic Algorithm for %d generations...\n', params.max_generations);
for gen = 1:params.max_generations
    
    [best_val, best_idx] = max(fitness_score);
    elite_ind = pop(best_idx, :);
    min_mse = mse(best_idx);
    
    best_mse_history(gen) = min_mse;
    if mod(gen, 100) == 0 || gen == 1
        fprintf('Gen %d | Best MSE: %.5f | Best Fitness: %.5f\n', ...
            gen, min_mse, best_val);
    end
    
    parents = selection(pop, fitness_score, params);
    offspring = crossover(parents, params);
    new_pop = mutation(offspring, params);
    new_pop(1, :) = elite_ind;
    [new_fit, new_mse] = fitness(new_pop, U, Y, params);
    
    pop = new_pop;
    fitness_score = new_fit;
    mse = new_mse;
end

[final_best_fit, idx] = max(fitness_score);
best_solution = pop(idx, :);

fprintf('\nFinal Result:\nBest MSE: %.5f\nBest Fitness: %.5f\n', ...
    mse(idx), final_best_fit);

figure;
plot(best_mse_history, 'LineWidth', 2);
yscale('log');
grid on;

title('GA Convergence History');
xlabel('Generation');
ylabel('Mean Squared Error (MSE)');