function print_expression(genes, params)

    fprintf('F(u1, u2) = \n');
    terms_printed = 0;
    for k = 1:params.num_gaussians
        [w, c1, s1, c2, s2] = decode(genes, k);
        
        if w ~= 0
            denom1 = 2 * s1^2;
            denom2 = 2 * s2^2;
            
            sign_str = '+';
            if w < 0, sign_str = '-'; end
            
            fprintf('   %s %.4f * exp( - ( (u1 - %.4f)^2 / %.4f + (u2 - %.4f)^2 / %.4f ) )\n', ...
                sign_str, abs(w), c1, denom1, c2, denom2);
            terms_printed = terms_printed + 1;
        end
    end
    
    if terms_printed == 0
        fprintf('   0 (All terms were pruned)\n');
    end
    fprintf('\n');
end