clear; clc; close all;

addpath('src');
addpath('utils');
parameters;

[U, Y] = generate_data(params.num_samples);

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

fprintf('\n--- STARTING VALIDATION ---\n');

[U_val, Y_val] = generate_data(params.num_samples);

val_params = params;
val_params.pop_size = 1;

[~, val_mse] = fitness(best_solution, U_val, Y_val, val_params);

fprintf('Training MSE:   %.5f\n', mse(idx));
fprintf('Validation MSE: %.5f\n', val_mse);

if val_mse > 2*mse(idx)
    fprintf('WARNING: Possible overfitting detected. Consider increasing mutation or reducing gaussians.\n');
else
    fprintf('SUCCESS: The model generalizes well to new data.\n');
end

figure('Name', 'Validation: Actual vs Predicted');

u1_grid = linspace(min(U_val(:,1)), max(U_val(:,1)), 50);
u2_grid = linspace(min(U_val(:,2)), max(U_val(:,2)), 50);
[U1_Mesh, U2_Mesh] = meshgrid(u1_grid, u2_grid);

Y_Real = sin(U1_Mesh + U2_Mesh) .* sin(U2_Mesh.^2);
Y_Pred = zeros(size(U1_Mesh));
K = params.num_gaussians;
genes = best_solution;

for k = 1:K
    idx = (k-1)*5;
    w  = genes(idx+1);
    c1 = genes(idx+2);
    s1 = genes(idx+3);
    c2 = genes(idx+4);
    s2 = genes(idx+5);
    
    term1 = (U1_Mesh - c1).^2 ./ (2*s1^2 + eps);
    term2 = (U2_Mesh - c2).^2 ./ (2*s2^2 + eps);
    Y_Pred = Y_Pred + w*exp(-(term1 + term2));
end

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

threshold = params.pruning_threshold;
simplified_genes = best_solution;
active_gaussians = 0;

fprintf('\n--- SIMPLIFICATION REPORT ---\n');
fprintf('Pruning terms with weight magnitude < %.2f...\n', threshold);

for k = 1:K
    idx = (k-1)*5;
    w = best_solution(idx+1);
    
    if abs(w) < threshold
        simplified_genes(idx+1) = 0; 
    else
        active_gaussians = active_gaussians + 1;
        fprintf('  Term %2d kept: w = %6.3f, c = [%.2f, %.2f], s = [%.2f, %.2f]\n', ...
            k, w, best_solution(idx+2), best_solution(idx+4), best_solution(idx+3), best_solution(idx+5));
    end
end

[~, simple_mse] = fitness(simplified_genes, U_val, Y_val, val_params);

fprintf('\nOriginal Gaussians: %d | MSE: %.5f\n', params.num_gaussians, val_mse);
fprintf('Active Gaussians:   %d | MSE: %.5f\n', active_gaussians, simple_mse);

if simple_mse < 1.1*val_mse
    fprintf('>> SUCCESS: Model simplified significantly with minimal accuracy loss.\n');
else
    fprintf('>> WARNING: Pruning hurt accuracy too much. Consider a lower threshold.\n');
end

fprintf('\n--- FINAL ESTIMATED ANALYTICAL EXPRESSION ---\n');
fprintf('F(u1, u2) = \n');

K = params.num_gaussians;
terms_printed = 0;

for k = 1:K
    idx = (k-1)*5;
    w = simplified_genes(idx+1);
    
    if w ~= 0
        c1 = simplified_genes(idx+2);
        s1 = simplified_genes(idx+3);
        c2 = simplified_genes(idx+4);
        s2 = simplified_genes(idx+5);
        
        denom1 = 2*s1^2;
        denom2 = 2*s2^2;
        
        if w >= 0
            sign_str = '+';
        else
            sign_str = '-';
        end
        
        fprintf('   %s %.4f * exp( - ( (u1 - %.4f)^2 / %.4f + (u2 - %.4f)^2 / %.4f ) )\n', ...
            sign_str, abs(w), c1, denom1, c2, denom2);
            
        terms_printed = terms_printed + 1;
    end
end

if terms_printed == 0
    fprintf('   0 (All terms were pruned)\n');
end
fprintf('\n');