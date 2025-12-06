function save_figures()

    st = dbstack;
    if length(st) > 1
        taskName = st(2).name; 
    else
        taskName = 'matlab_figure';
    end

    rootDir = fileparts(mfilename('fullpath'));
    outputDir = fullfile(rootDir, 'report', 'assets');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
        fprintf('Created directory: %s\n', outputDir);
    end

    figs = findobj('Type', 'figure');
    if isempty(figs)
        fprintf('No open figures to save.\n');
        return;
    end
    
    [~, idx] = sort([figs.Number]);
    figs = figs(idx);

    fprintf('Saving figures to: %s\n', outputDir);
    for i = 1:numel(figs)
        hFig = figs(i);
        
        if numel(figs) == 1
            filename = sprintf('%s.jpg', taskName);
        else
            filename = sprintf('%s_%d.jpg', taskName, hFig.Number);
        end
        fullPath = fullfile(outputDir, filename);
        
        try
            exportgraphics(hFig, fullPath, 'Resolution', 300);
            fprintf('  Saved: %s\n', filename);
        catch
            saveas(hFig, fullPath);
            fprintf('  Saved (via saveas): %s\n', filename);
        end
    end
end