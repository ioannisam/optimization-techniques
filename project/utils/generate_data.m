function [U, Y] = generate_data(samples)

    u1_min = -1; u1_max = 2;
    u2_min = -2; u2_max = 1;
    
    u1 = (u1_max - u1_min)*rand(samples, 1) + u1_min;
    u2 = (u2_max - u2_min)*rand(samples, 1) + u2_min;
    
    Y = objective_function(u1, u2);
    
    U = [u1, u2];
end