clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
addpath(fullfile(script_folder, '..'));
run(fullfile(script_folder, '..', 'objective_functions.m'));

%% 1) Vary l - fevals/l
l_values = 0.01:0.005:0.1;
e = 0.001;

figure;
sgtitle('Fibonacci: Function evaluations vs l', 'FontWeight','bold');
for i = 1:3
    fevals_l = zeros(size(l_values));
    for j = 1:length(l_values)
        l = l_values(j);
        [~,~,~,fevals,~] = fibonacci(funcs{i}, a1, b1, l, e);
        fevals_l(j) = fevals;
    end
    subplot(3,1,i);
    plot(l_values, fevals_l, '-o', 'LineWidth',1.2);
    xlabel('l'); ylabel('Function evaluations');
    title(['Function ', fnames{i}], 'FontWeight','bold', 'FontSize', 12);
    grid on;
end

%% 2) Vary l - history/k
l_values = [0.1, 0.01, 0.003];
colors = lines(length(l_values));

figure;
sgtitle('Fibonacci: Interval endpoints a_k, b_k vs iteration k for different l', 'FontWeight','bold');
for i = 1:3
    for j = 1:length(l_values)
        l = l_values(j);
        [~, ~, ~, ~, history] = fibonacci(funcs{i}, a1, b1, l, e);

        subplot(3,3,(i-1)*3 + j); hold on;
        plot(1:length(history.a), history.a, '--', 'Color', colors(j,:), 'Marker', 'o', 'LineWidth',1.2, 'DisplayName', 'a_k');
        plot(1:length(history.b), history.b, '-',  'Color', colors(j,:), 'Marker', 'o', 'LineWidth',1.2, 'DisplayName', 'b_k');
        xlabel('Iteration k'); ylabel('a_k, b_k');
        title([fnames{i}, ', l=', num2str(l)], 'FontWeight','bold', 'FontSize', 12);
        grid on;
        legend('show');
    end
end

save_figures();