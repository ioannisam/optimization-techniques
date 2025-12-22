function start_logging()

    utilsDir  = fileparts(mfilename('fullpath'));
    rootDir   = fileparts(utilsDir);
    outputDir = fullfile(rootDir, 'report', 'assets');
    
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    logFile = fullfile(outputDir, 'results.txt');
    if exist(logFile, 'file')
        delete(logFile);
    end
    
    diary(logFile);
    fprintf('--- Logging started: %s ---\n', datestr(now));
end