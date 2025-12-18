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