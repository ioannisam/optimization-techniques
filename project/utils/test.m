function test(num_samples)

    [U, Y] = generate_data(num_samples);

    figure;
    plot3(U(:,1), U(:,2), Y, 'o', ...
          'MarkerSize', 8, ...
          'MarkerFaceColor', 'b', ...
          'MarkerEdgeColor', 'k');
    grid on;

    title(sprintf('Training Data Distribution (N=%d)', num_samples));
    xlabel('u_1'); ylabel('u_2'); zlabel('y');
end