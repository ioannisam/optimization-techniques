function [w, c1, s1, c2, s2] = decode(genes, k)
    idx = 5*(k-1);
    
    w  = genes(idx + 1);
    c1 = genes(idx + 2);
    s1 = genes(idx + 3);
    c2 = genes(idx + 4);
    s2 = genes(idx + 5);
end