clear; clc; close all;

addpath('src');
addpath('utils');
parameters;

[U, Y] = generate_data(params.num_samples);

% black box approach
params.c1_range = [min(U(:,1)), max(U(:,1))];
params.c2_range = [min(U(:,2)), max(U(:,2))];
fprintf('Search space adjusted to data:\n  u1: [%.2f, %.2f]\n  u2: [%.2f, %.2f]\n\n', ...
    params.c1_range(1), params.c1_range(2), ...
    params.c2_range(1), params.c2_range(2));

pop = initialize_population(params);
disp(['Population created with size: ', num2str(size(pop))]);

[fit, err] = fitness(pop, U, Y, params);
disp('First 5 individuals stats:');
disp(table(fit(1:5), err(1:5), 'VariableNames', {'Fitness', 'MSE'}));

fprintf('--- Running Selection (Roulette Wheel) ---\n');

parents = selection(pop, fit, params);
disp(['Parents matrix size: ', num2str(size(parents))]);

if size(parents, 1) == params.pop_size
    disp('>> Selection successful!');
else
    disp('>> Error: Parents matrix has incorrect size.');
end

fprintf('--- Running Crossover (Rate: %.2f) ---\n', params.crossover_rate);

offspring = crossover(parents, params);
disp(['Offspring matrix size: ', num2str(size(offspring))]);

if isequal(parents, offspring)
    disp('>> Note: No crossover occurred (random chance or rate=0).');
else
    disp('>> Crossover successful! New generation created.');
end

fprintf('--- Running Mutation (Rate: %.2f, Noise: %.2f) ---\n', ...
    params.mutation_rate, params.mutation_noise);

new_pop = mutation(offspring, params);

diff_matrix = new_pop - offspring;
num_mutations = sum(diff_matrix(:) ~= 0);
total_genes = numel(new_pop);

fprintf('>> Mutation complete. %d genes mutated out of %d (%.2f%%)\n', ...
    num_mutations, total_genes, (num_mutations/total_genes)*100);

[new_fit, new_err] = fitness(new_pop, U, Y, params);
disp('Stats of the new generation (Best 5):');
[sorted_fit, idx] = sort(new_fit, 'descend');
sorted_err = new_err(idx);
disp(table(sorted_fit(1:5), sorted_err(1:5), 'VariableNames', {'Fitness', 'MSE'}));