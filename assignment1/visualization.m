clear; clc; close all;

objective_functions;

x_vals = linspace(a1, b1, 1000);
f1_vals = f1(x_vals);
f2_vals = f2(x_vals);
f3_vals = f3(x_vals);

figure('Name','Objective Functions','NumberTitle','off');
sgtitle('Objective Functions over [-1,3]', 'FontWeight','bold');

subplot(3,1,1);
plot(x_vals, f1_vals,'LineWidth',1.5);
grid on; xlabel('x'); ylabel('f_1(x)');
title('Function f_1(x) = 5^x + (2-cos(x))^2');

subplot(3,1,2);
plot(x_vals, f2_vals,'LineWidth',1.5);
grid on; xlabel('x'); ylabel('f_2(x)');
title('Function f_2(x) = (x-1)^2 + e^{x-5} \cdot sin(x+3)');

subplot(3,1,3);
plot(x_vals, f3_vals,'LineWidth',1.5);
grid on; xlabel('x'); ylabel('f_3(x)');
title('Function f_3(x) = exp(-3x) - (sin(x-2)-2)^2');