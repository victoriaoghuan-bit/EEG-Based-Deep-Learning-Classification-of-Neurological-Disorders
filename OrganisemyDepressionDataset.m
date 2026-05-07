% EEG File Selection Script
% Selects 100 files from each category (rd, rn, ld, ln)

% Set your path
dataPath = 'M:\pc\Downloads\Depression\Depression';

% Get all .txt files
allFiles = dir(fullfile(dataPath, '*.txt'));
fileNames = {allFiles.name};

% Initialize arrays to store file names for each category
rdFiles = {};
rnFiles = {};
ldFiles = {};
lnFiles = {};

% Categorize files based on prefix
for i = 1:length(fileNames)
    fileName = fileNames{i};
    
    if startsWith(fileName, 'rd')
        rdFiles{end+1} = fileName;
    elseif startsWith(fileName, 'rn')
        rnFiles{end+1} = fileName;
    elseif startsWith(fileName, 'ld')
        ldFiles{end+1} = fileName;
    elseif startsWith(fileName, 'ln')
        lnFiles{end+1} = fileName;
    end
end

% Display counts
fprintf('Found files:\n');
fprintf('rd (Right Depression): %d files\n', length(rdFiles));
fprintf('rn (Right Normal): %d files\n', length(rnFiles));
fprintf('ld (Left Depression): %d files\n', length(ldFiles));
fprintf('ln (Left Normal): %d files\n', length(lnFiles));

% Select first 100 from each category (or all if less than 100)
numToSelect = 100;

selectedRd = rdFiles(1:min(numToSelect, length(rdFiles)));
selectedRn = rnFiles(1:min(numToSelect, length(rnFiles)));
selectedLd = ldFiles(1:min(numToSelect, length(ldFiles)));
selectedLn = lnFiles(1:min(numToSelect, length(lnFiles)));

% Create output folders
outputPath = fullfile(dataPath, 'Selected_EEG_Data');
normalPath = fullfile(outputPath, 'Normal');
depressionPath = fullfile(outputPath, 'Depression');

% Create directories if they don't exist
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end
if ~exist(normalPath, 'dir')
    mkdir(normalPath);
end
if ~exist(depressionPath, 'dir')
    mkdir(depressionPath);
end

% Copy Normal files (rn + ln)
fprintf('\nCopying Normal files...\n');
fileCounter = 1;
for i = 1:length(selectedRn)
    srcFile = fullfile(dataPath, selectedRn{i});
    destFile = fullfile(normalPath, sprintf('normal_%03d.txt', fileCounter));
    copyfile(srcFile, destFile);
    fileCounter = fileCounter + 1;
end

for i = 1:length(selectedLn)
    srcFile = fullfile(dataPath, selectedLn{i});
    destFile = fullfile(normalPath, sprintf('normal_%03d.txt', fileCounter));
    copyfile(srcFile, destFile);
    fileCounter = fileCounter + 1;
end

% Copy Depression files (rd + ld)
fprintf('Copying Depression files...\n');
fileCounter = 1;
for i = 1:length(selectedRd)
    srcFile = fullfile(dataPath, selectedRd{i});
    destFile = fullfile(depressionPath, sprintf('depression_%03d.txt', fileCounter));
    copyfile(srcFile, destFile);
    fileCounter = fileCounter + 1;
end

for i = 1:length(selectedLd)
    srcFile = fullfile(dataPath, selectedLd{i});
    destFile = fullfile(depressionPath, sprintf('depression_%03d.txt', fileCounter));
    copyfile(srcFile, destFile);
    fileCounter = fileCounter + 1;
end

% Display final results
fprintf('\nFile selection and organization complete!\n');
fprintf('Normal files: %d (in %s)\n', length(selectedRn) + length(selectedLn), normalPath);
fprintf('Depression files: %d (in %s)\n', length(selectedRd) + length(selectedLd), depressionPath);
fprintf('Total files: %d\n', length(selectedRn) + length(selectedLn) + length(selectedRd) + length(selectedLd));