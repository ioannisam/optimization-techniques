function y = objective_function(u1, u2)
    y = sin(u1 + u2) .* sin(u2.^2);
end