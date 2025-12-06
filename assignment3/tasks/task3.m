clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
run(fullfile(script_folder, '..', 'objective_functions.m'));

x0 = [-5; 10];
gamma_fixed = 0.1;
sk = 15;

[x_star, k, evals, history] = steepest_descend_projection(f_wr, gf_wr, P, x0, sk, gamma_fixed, e);

figure;
fx_history = history.f;
conv = abs(fx_history - fx_history(end)) + eps;
semilogy(0:numel(fx_history)-1, conv, '-o', 'MarkerSize', 6, 'LineWidth', 1.5);
grid on;
title('Projected Descent: Convergence history vs iteration k', 'FontWeight','bold');
xlabel('Iteration k');
ylabel('|f(x_k) - f(x^*)|');

x1_min = -12; x1_max = 7;
x2_min = -10; x2_max = 14;
[xg, yg] = meshgrid(linspace(x1_min, x1_max, 100), linspace(x2_min, x2_max, 100));
zg = f(xg, yg);

figure;
[~, hContour] = contourf(xg, yg, zg, 20);
colormap jet;
hold on;

rectangle('Position', [-10, -8, 15, 20], 'EdgeColor', 'k', 'LineWidth', 3, 'LineStyle', '-');
hRect = plot(NaN, NaN, 'k-', 'LineWidth', 3);

path_x = history.x(1, :);
path_y = history.x(2, :);

hTraj = plot(path_x, path_y, 'w-o', 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'r');
hStart = plot(path_x(1), path_y(1), 'gs', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'g');
hEnd = plot(path_x(end), path_y(end), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'r');

title(sprintf('Projected Descent: Trajectory (s_k=%g, \\gamma=%g)', sk, gamma_fixed), 'FontWeight', 'bold');
xlabel('x_1');
ylabel('x_2');
grid on;

legend([hContour, hRect, hTraj, hStart, hEnd], ...
       {'Iso-contours', 'Feasible Region', 'Trajectory', 'Start', 'End'}, ...
       'Location', 'north');

hold off;