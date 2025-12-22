function start_logging()

    utilsDir  = fileparts(mfilename('fullpath'));
    rootDir   = fileparts(utilsDir);
    outputDir = fullfile(rootDir, 'report', 'assets');
    
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    logFile = fullfile(outputDir, 'results.txt');

    diary off
    diary(logFile)

    timestamp = datetime('now','Format','yyyy-MM-dd HH:mm:ss');
    fprintf('--- Logging started: %s ---\n', timestamp);
end
