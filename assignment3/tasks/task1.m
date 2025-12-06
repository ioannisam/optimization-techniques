clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
run(fullfile(script_folder, '..', 'objective_functions.m'));
output_dir = fullfile(script_folder, '..', 'report', 'assets');
output_file = fullfile(output_dir, 'task1_results.csv');

x0 = [5; -5];
gammas = [0.1, 0.3, 3, 5];
ngammas = numel(gammas);

results = cell(ngammas, 7);
histories = cell(ngammas, 1);

row = 0;
for j = 1:ngammas
    row = row + 1;
    gamma_fixed = gammas(j);
    [xk, k, evals, history] = steepest_descend(f_wr, gf_wr, x0, gamma_fixed, e);

    iterations = numel(history.f) - 1;
    fmin = history.f(end);
    fevals_total = evals.fevals + evals.gevals;
    sevals = evals.sevals;
    xmin = xk(:).';

    results{row,1} = x0(:).';
    results{row,2} = gamma_fixed;
    results{row,3} = xmin(:).';
    results{row,4} = fmin;
    results{row,5} = iterations;
    results{row,6} = fevals_total;
    results{row,7} = sevals;

    histories{row} = history;
end


fid = fopen(output_file,'w');
fprintf(fid, 'Initial Point,Gamma,Minimum Point x*,Minimum Value f(x*),Iterations,Function Evaluations,Step Evaluations\n');
for r = 1:size(results, 1)
    fprintf(fid, '[%g %g],%g,[%.3g %.3g],%.3g,%d,%d,%d\n', results{r,:});
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

    init = sprintf('[%g %g]', x0(1), x0(2));
    gamma = sprintf('gamma=%.3g', results{j,2});

    title(sprintf('init=%s | %s', init, gamma), 'FontWeight', 'bold');
    xlabel('Iteration k');
    ylabel('|f_{x_0} - f_{x^*}|');
end