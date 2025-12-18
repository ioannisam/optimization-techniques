clear; clc; close all;

[U, Y] = generate_data(100);

figure;
plot3(U(:,1), U(:,2), Y, 'o', ...
      'MarkerSize', 8, ...
      'MarkerFaceColor', 'b', ...
      'MarkerEdgeColor', 'k');
grid on;

title('Training Data Distribution');
xlabel('u_1'); ylabel('u_2'); zlabel('y');