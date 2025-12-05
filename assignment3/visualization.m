clear; clc; close all;

objective_functions;

x1_min = -10;  x1_max = 5;
x2_min = -8;   x2_max = 12;

[xg, yg] = meshgrid(linspace(x1_min-5, x1_max+5, 400), linspace(x2_min-5, x2_max+5, 400));
zg = f(xg, yg);

xmin = [0, 0];
fmin = f(xmin(1), xmin(2));

%% Surface Plot
figure;
surf(xg, yg, zg);
shading interp;
colormap jet;
hold on;

title('Surface Plot of f(x_1,x_2) = (1/3)x_1^2 + 3x_2^2');
xlabel('x_1');
ylabel('x_2');
zlabel('f(x)');
colorbar;

min_surf = plot3(xmin(1), xmin(2), fmin, 'r*', 'MarkerSize', 24, 'LineWidth', 3);

zmax = max(zg(:));
X = [x1_min x1_max x1_max x1_min];
Y = [x2_min x2_min x2_max x2_max];
fill3(X, Y, [0 0 0 0], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);
fill3(X, Y, [zmax zmax zmax zmax], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);
fill3([x1_min x1_max x1_max x1_min], [x2_min x2_min x2_min x2_min], [0 0 zmax zmax], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);
fill3([x1_max x1_max x1_max x1_max], [x2_min x2_max x2_max x2_min], [0 0 zmax zmax], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);
fill3([x1_min x1_max x1_max x1_min], [x2_max x2_max x2_max x2_max], [0 0 zmax zmax], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);
fill3([x1_min x1_min x1_min x1_min], [x2_min x2_max x2_max x2_min], [0 0 zmax zmax], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth',1.5);

legend(min_surf, 'Unconstrained Minimum f(0,0)=0', 'Location', 'northeast');

hold off;

%% Contour Plot
figure;
contourf(xg, yg, zg, 40);
shading interp;
colormap jet;
hold on;

title('Contour Plot of f(x_1,x_2) = (1/3)x_1^2 + 3x_2^2');
xlabel('x_1');
ylabel('x_2');
colorbar;

min_cont = plot(xmin(1), xmin(2), 'r*', 'MarkerSize', 20, 'LineWidth', 3);

plot([x1_min x1_max x1_max x1_min x1_min], [x2_min x2_min x2_max x2_max x2_min], 'k-', 'LineWidth', 4);

legend(min_cont, 'Unconstrained Minimum f(0,0)=0', 'Location', 'northeast');

hold off;