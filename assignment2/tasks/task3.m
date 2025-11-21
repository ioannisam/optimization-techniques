clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
run(fullfile(script_folder, '..', 'objective_functions.m'));
output_dir = fullfile(script_folder, '..', 'report', 'assets');
output_file = fullfile(output_dir, 'task3_results.csv');

results = cell(npoints*nmethods, 7);
histories = cell(npoints*nmethods, 1);

row = 0;
for i = 1:npoints
    x0 = initial_points{i}(:);
    for j = 1:nmethods
        row = row + 1;
        method = methods{j};
        [xk, k, evals, history] = newton(f_wr, gf_wr, hf_wr, x0, gamma_fixed, e, method);
        

        iterations = numel(history.f) - 1;
        fmin = history.f(end);
        fevals_total = evals.fevals + evals.gevals;
        sevals = evals.sevals;
        xmin = xk(:).';
        
        results{row,1} = x0(:).';
        results{row,2} = method;
        results{row,3} = xmin(:).';
        results{row,4} = fmin;
        results{row,5} = iterations;
        results{row,6} = fevals_total;
        results{row,7} = sevals;

        histories{row} = history;
    end
end

fid = fopen(output_file,'w');
fprintf(fid, 'Initial Point,Method,Minimum Point x*,Minimum Value f(x*),Iterations,Function Evaluations,Step Evaluations\n');
for r = 1:size(results,1)
    fprintf(fid, '[%g %g],%s,[%.3g %.3g],%.3g,%d,%d,%d\n', results{r,:});
end
fclose(fid);

figure;
sgtitle('Newton: Convergence history vs iteration k', 'FontWeight','bold');
for i = 1:npoints
    for j = 1:nmethods
        idx = (i-1)*nmethods + j;

        history = histories{idx};
        hs = history.f(:);
        conv = abs(hs-hs(end)) + eps;

        subplot(npoints, nmethods, idx);
        semilogy(0:numel(hs)-1, conv, '-o', 'MarkerSize',4);
        grid on;

        init = sprintf('[%g %g]', results{idx,1});
        title(sprintf('init=%s | %s', init, results{idx,2}), 'FontWeight', 'bold');
        xlabel('Iteration k');
        ylabel('|f_{x_0} - f_{x^*}|');
    end
end