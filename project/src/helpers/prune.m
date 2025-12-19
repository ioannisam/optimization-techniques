function [pruned_genes, active_count] = prune(genes, params)
    pruned_genes = genes;
    threshold = params.pruning_threshold;
    
    weights_idx = 1:5:length(genes);
    weights = genes(weights_idx);
    
    to_prune = abs(weights) < threshold;
    
    pruned_genes(weights_idx(to_prune)) = 0;
    active_count = sum(~to_prune);
end