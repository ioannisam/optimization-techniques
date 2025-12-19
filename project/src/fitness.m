function [fitness, mse] = fitness(pop, U, Y, params)
    N = size(pop, 1);
    fitness = zeros(N, 1);
    mse = zeros(N, 1);  
    
    for i = 1:N
        Y_pred = evaluate(pop(i, :), U, params);
        
        error = Y - Y_pred;
        mse(i) = mean(error.^2);
        fitness(i) = 1 / (1 + mse(i));
    end
end