function Y_pred = evaluate(genes, U, params)

    u1 = U(:, 1);
    u2 = U(:, 2);
    Y_pred = zeros(size(u1));
    
    K = params.num_gaussians;
    for k = 1:K
        [w, c1, s1, c2, s2] = decode(genes, k);
        
        term1 = (u1 - c1).^2 ./ (2*s1^2 + eps);
        term2 = (u2 - c2).^2 ./ (2*s2^2 + eps);
        Y_pred = Y_pred + w * exp(-(term1 + term2));
    end
end