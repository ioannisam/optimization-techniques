clear; clc; close all;

script_folder = fileparts(mfilename('fullpath'));
addpath(fullfile(script_folder, '..', 'src'));
addpath(fullfile(script_folder, '..'));
run(fullfile(script_folder, '..', 'objective_functions.m'));

x0 = initial_points{2};
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'off');
[xmin, fmin] = fminunc(@(v) f(v(1), v(2)), x0, options);

[xg, yg] = meshgrid(linspace(-3, 3, 200), linspace(-3, 3, 200));
zg = f(xg, yg);

%% Surface Plot
figure;
surf(xg, yg, zg);
shading interp;
colormap jet;
hold on;

title('Surface Plot of f(x,y) = x^3e^{-x^2-y^4}');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');
colorbar;

min_surf = plot3(xmin(1), xmin(2), fmin, 'r*', 'MarkerSize', 24, 'LineWidth', 3);
text_surf = sprintf(['Local Minimum\nx = %.3f\ny = %.3f\nz = %.3f'], xmin(1), xmin(2), fmin);
legend(min_surf, text_surf, 'Location', 'northeast');

hold off;

%% Contour Plot
figure;
contourf(xg, yg, zg, 40);
shading interp;
colormap jet;
hold on;

title('Contour Plot of f(x,y) = x^3e^{-x^2-y^4}');
xlabel('x');
ylabel('y');
colorbar;

min_cont = plot(xmin(1), xmin(2), 'r*', 'MarkerSize', 24, 'LineWidth', 3);
text_contour = sprintf(['Local Minimum\nx = %.3f\ny = %.3f\nz = %.3f'], xmin(1), xmin(2), fmin);
legend(min_cont, text_contour, 'Location', 'northeast');

hold off;

save_figures();