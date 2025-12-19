function [fitness, mse] = fitness(pop, U, Y, params)

    N = size(pop, 1);
    M = size(U, 1);
    K = params.num_gaussians;

    u1 = U(:, 1);
    u2 = U(:, 2);
    
    fitness = zeros(N, 1);
    mse = zeros(N, 1);  
    for i = 1:N
        chromosome = pop(i, :);
        
        Y_pred = zeros(M, 1);
        for j = 1:K
            idx = (j-1)*5;
            
            % decode chromosome
            w  = chromosome(idx+1);
            c1 = chromosome(idx+2);
            s1 = chromosome(idx+3);
            c2 = chromosome(idx+4);
            s2 = chromosome(idx+5);
            
            % sum gaussian formula
            term1 = (u1 - c1).^2 ./ (2*s1^2 + eps);
            term2 = (u2 - c2).^2 ./ (2*s2^2 + eps);
            Y_pred = Y_pred + w*exp(-(term1 + term2));
        end
        
        error = Y - Y_pred;
        mse(i) = mean(error.^2);
        fitness(i) = 1 / (1 + mse(i));
    end
end