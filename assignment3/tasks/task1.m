clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
addpath(fullfile(script_folder, '..'));
run(fullfile(script_folder, '..', 'objective_functions.m'));
output_dir = fullfile(script_folder, '..', 'report', 'assets');
output_file = fullfile(output_dir, 'task1_results.csv');

x0 = [5; -5];
gammas = [0.1, 0.3, 3, 5];
ngammas = numel(gammas);

results = cell(ngammas, 6);
histories = cell(ngammas, 1);

row = 0;
for j = 1:ngammas
    row = row + 1;
    gamma_fixed = gammas(j);
    [xk, k, evals, history] = steepest_descend(f_wr, gf_wr, x0, gamma_fixed, e);

    iterations = numel(history.f) - 1;
    fmin = history.f(end);
    fevals_total = evals.fevals + evals.gevals;
    xmin = xk(:).';

    results{row,1} = gamma_fixed;
    results{row,2} = x0(:).';
    results{row,3} = xmin(:).';
    results{row,4} = fmin;
    results{row,5} = iterations;
    results{row,6} = fevals_total;

    histories{row} = history;
end


fid = fopen(output_file,'w');
fprintf(fid, 'Gamma,Initial Point,Minimum Point x*,Minimum Value f(x*),Iterations,Function Evaluations\n');
for r = 1:size(results, 1)
    fprintf(fid, '%g,[%g %g],[%.3g %.3g],%.3g,%d,%d\n', results{r,:});
end
fclose(fid);

figure;
sgtitle('Steepest Descend: Convergence history vs iteration k', 'FontWeight','bold');
for j = 1:ngammas
    history = histories{j};
    hs = history.f(:);
    conv = abs(hs - hs(end)) + eps;

    subplot(1, ngammas, j);
    semilogy(0:numel(hs)-1, conv, '-o', 'MarkerSize', 4);
    grid on;

    title(sprintf('gamma=%.3g', results{j,1}), 'FontWeight', 'bold');
    xlabel('Iteration k');
    ylabel('|f_{x_0} - f_{x^*}|');
end

x1_min = -6; x1_max = 6;
x2_min = -6; x2_max = 6;
[xg, yg] = meshgrid(linspace(x1_min, x1_max, 100), linspace(x2_min, x2_max, 100));
zg = f(xg, yg); 
zg = reshape(zg, size(xg));

figure;
sgtitle('Steepest Descent: Trajectory', 'FontWeight', 'bold');
for i = 1:ngammas
    subplot(2, 2, i);
    
    [~, hContour] = contourf(xg, yg, zg, 20); 
    colormap jet;
    hold on;
    
    path_x = histories{i}.x(1, :);
    path_y = histories{i}.x(2, :);

    hTraj = plot(path_x, path_y, 'w-o', 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'r');
    hStart = plot(path_x(1), path_y(1), 'gs', 'MarkerSize', 8, 'LineWidth', 2, 'MarkerFaceColor', 'g');
    hEnd = plot(path_x(end), path_y(end), 'rx', 'MarkerSize', 10, 'LineWidth', 2,  'MarkerFaceColor', 'r');

    title(sprintf('Gamma = %g', results{i,1}));
    xlabel('x_1'); 
    ylabel('x_2');
    grid on;
    
    xlim([x1_min x1_max]);
    ylim([x2_min x2_max]);

    hold off;
end

legend([hContour, hTraj, hStart, hEnd], ...
       {'Iso-contours', 'Trajectory', 'Start', 'End'}, ...
       'Location', 'north');

save_figures();