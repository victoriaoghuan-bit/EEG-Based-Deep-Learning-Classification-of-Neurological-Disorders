% EEG Preprocessing Script
% Applies bandpass filtering and normalization

% Set paths
basePath = 'M:\pc\Downloads\Depression\Depression\Selected_EEG_Data';
normalPath = fullfile(basePath, 'Normal');
depressionPath = fullfile(basePath, 'Depression');

% Create output folders for preprocessed data
outputPath = fullfile(basePath, 'Preprocessed_Data');
normalOutputPath = fullfile(outputPath, 'Normal');
depressionOutputPath = fullfile(outputPath, 'Depression');

% Create directories if they don't exist
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end
if ~exist(normalOutputPath, 'dir')
    mkdir(normalOutputPath);
end
if ~exist(depressionOutputPath, 'dir')
    mkdir(depressionOutputPath);
end

% Preprocessing parameters
fs = 256;  % Sampling frequency (Hz)
lowCutoff = 1;   % Low cutoff frequency (Hz)
highCutoff = 50; % High cutoff frequency (Hz)

% Design bandpass filter
[b, a] = butter(4, [lowCutoff highCutoff]/(fs/2), 'bandpass');

% Process Normal files
fprintf('Processing Normal files...\n');
normalFiles = dir(fullfile(normalPath, '*.txt'));
for i = 1:length(normalFiles)
    % Load EEG data
    filePath = fullfile(normalPath, normalFiles(i).name);
    eegData = load(filePath);
    
    % Apply bandpass filter
    filteredData = filtfilt(b, a, eegData);
    
    % Normalize data (z-score normalization)
    normalizedData = (filteredData - mean(filteredData)) / std(filteredData);
    
    % Save preprocessed data
    outputFile = fullfile(normalOutputPath, normalFiles(i).name);
    save(outputFile, 'normalizedData', '-ascii');
    
    if mod(i, 50) == 0
        fprintf('Processed %d/%d Normal files\n', i, length(normalFiles));
    end
end

% Process Depression files
fprintf('Processing Depression files...\n');
depressionFiles = dir(fullfile(depressionPath, '*.txt'));
for i = 1:length(depressionFiles)
    % Load EEG data
    filePath = fullfile(depressionPath, depressionFiles(i).name);
    eegData = load(filePath);
    
    % Apply bandpass filter
    filteredData = filtfilt(b, a, eegData);
    
    % Normalize data (z-score normalization)
    normalizedData = (filteredData - mean(filteredData)) / std(filteredData);
    
    % Save preprocessed data
    outputFile = fullfile(depressionOutputPath, depressionFiles(i).name);
    save(outputFile, 'normalizedData', '-ascii');
    
    if mod(i, 50) == 0
        fprintf('Processed %d/%d Depression files\n', i, length(depressionFiles));
    end
end

fprintf('\nPreprocessing complete!\n');
fprintf('Preprocessed files saved in: %s\n', outputPath);
fprintf('Normal files: %d\n', length(normalFiles));
fprintf('Depression files: %d\n', length(depressionFiles));

% Optional: Plot example of preprocessing
if ~isempty(normalFiles)
    % Load original and preprocessed data for comparison
    originalData = load(fullfile(normalPath, normalFiles(1).name));
    preprocessedData = load(fullfile(normalOutputPath, normalFiles(1).name));
    
    figure;
    subplot(2,1,1);
    plot(originalData);
    title('Original EEG Signal');
    xlabel('Sample');
    ylabel('Amplitude');
    
    subplot(2,1,2);
    plot(preprocessedData);
    title('Preprocessed EEG Signal (Filtered + Normalized)');
    xlabel('Sample');
    ylabel('Normalized Amplitude');
    
    fprintf('Example preprocessing plot created.\n');
end