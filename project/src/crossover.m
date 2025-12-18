function offspring = crossover(parents, params)

    [N, ~] = size(parents);
    offspring = parents;
    
    rate = params.crossover_rate;
    
    for i = 1:2:(N-1)
        
        if rand() < rate
            p1 = parents(i, :);
            p2 = parents(i+1, :);
            
            alpha = rand(); 
            
            c1 = alpha*p1 + (1-alpha)*p2;
            c2 = (1-alpha)*p1 + alpha*p2;
            
            offspring(i, :)   = c1;
            offspring(i+1, :) = c2;
        end
    end
end