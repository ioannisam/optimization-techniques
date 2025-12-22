clear; clc; close all;

addpath('src');
addpath('src/helpers');
addpath('utils');
parameters;

test(100);
test(10000);

[U, Y] = generate_data(params.num_samples);

fprintf('Initializing population...\n');
pop = initialize_population(params);

[fitness_score, mse] = fitness(pop, U, Y, params);
best_mse_history = zeros(params.max_generations, 1);

fprintf('Starting Genetic Algorithm for %d generations...\n', params.max_generations);
timerVal = tic;
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
elapsedTime = toc(timerVal);
fprintf('\nTotal Execution Time: %.2f seconds\n', elapsedTime);

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

fprintf('\n--- STARTING VALIDATION ---\n');

[U_val, Y_val] = generate_data(params.num_samples);

val_params = params;
val_params.pop_size = 1;

[~, val_mse] = fitness(best_solution, U_val, Y_val, val_params);

fprintf('Training MSE:   %.5f\n', mse(idx));
fprintf('Validation MSE: %.5f\n', val_mse);

if val_mse > 2*mse(idx)
    fprintf('WARNING: Possible overfitting detected.\n');
else
    fprintf('SUCCESS: The model generalizes well to new data.\n');
end

figure;

u1_grid = linspace(min(U_val(:,1)), max(U_val(:,1)), 50);
u2_grid = linspace(min(U_val(:,2)), max(U_val(:,2)), 50);
[U1_Mesh, U2_Mesh] = meshgrid(u1_grid, u2_grid);

Y_Real = objective_function(U1_Mesh, U2_Mesh);
U_Grid_Flat = [U1_Mesh(:), U2_Mesh(:)];
Y_Pred_Flat = evaluate(best_solution, U_Grid_Flat, params);
Y_Pred = reshape(Y_Pred_Flat, size(U1_Mesh));

subplot(1, 2, 1);
surf(U1_Mesh, U2_Mesh, Y_Real);
title('Ground Truth Function');
xlabel('u1'); ylabel('u2'); zlabel('y');
shading interp; camlight;

subplot(1, 2, 2);
surf(U1_Mesh, U2_Mesh, Y_Pred);
title(['Approximation (MSE: ', num2str(val_mse, '%.4f'), ')']);
xlabel('u1'); ylabel('u2'); zlabel('y');
shading interp; camlight;

fprintf('\n--- SIMPLIFICATION REPORT ---\n');
fprintf('Pruning terms with weight magnitude < %.2f...\n', params.pruning_threshold);

[simplified_genes, active_gaussians] = prune(best_solution, params);

for k = 1:params.num_gaussians
    [w, c1, s1, c2, s2] = decode(simplified_genes, k);
    if w ~= 0
         fprintf('  Term %2d kept: w = %6.3f, c = [%.2f, %.2f], s = [%.2f, %.2f]\n', ...
            k, w, c1, c2, s1, s2);
    end
end

[~, simple_mse] = fitness(simplified_genes, U_val, Y_val, val_params);

fprintf('\nOriginal Gaussians: %d | MSE: %.5f\n', params.num_gaussians, val_mse);
fprintf('Active Gaussians:   %d | MSE: %.5f\n', active_gaussians, simple_mse);

if simple_mse < 1.1*val_mse
    fprintf('>> SUCCESS: Model simplified significantly with minimal accuracy loss.\n');
else
    fprintf('>> WARNING: Pruning hurt accuracy too much.\n');
end

fprintf('\n--- FINAL ESTIMATED ANALYTICAL EXPRESSION ---\n');
print_expression(simplified_genes, params);

save_figures();