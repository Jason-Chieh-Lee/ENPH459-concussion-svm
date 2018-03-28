function [featureMatrix] = extractFeatures(eegMat)
%EXTRACT_FEATURES Takes in the .mat file of EEG and returns a matrix
%containing 30 features (row) per channel (column)

%   This function takes in the EEG data as a .mat file, converts it to a
%   matlab matrix object then calls on power spectral analysis, Wavelet
%   decomposition, and shannon entropy functions to get a matrix back from
%   each function. Then the matrices are combined into a feature matrix and
%   returned.
%   Input: eegMat - .mat file containing the EEG data
%   Output: featureMatrix - 30x27 matrix containing features (row) of each
%   channel (column)

eegStruct = load(eegMat);
field = fieldnames(eegStruct);
fieldName = field{1};
eegMatrix = eegStruct.(fieldName);

[rows, cols] = size(eegMatrix);
featureMatrix = zeros(30,cols);

% Power Spectral Analysis
powerSpectralMatrix = powerSpectral(eegMatrix);

for k = 1:size(powerSpectralMatrix, 1)
   featureMatrix(k,:) = powerSpectralMatrix(k,:); 
end

% Wavelet Decomposition Analysis
waveletDecompMatrix = waveletDecompExtract(eegMatrix, db8);

for j = 1:size(powerSpectralMatrix, 1)
    k = k + 1;
    featureMatrix(k,:) = waveletDecompMatrix(j,:);
end

% Shannon Entropy Analysis
shannonEntropyMatrix = getShannonEntropy(eegMatrix);

for j = 1:size(shannonEntropyMatrix, 1)
    k = k + 1;
    featureMatrix(k,:) = shannonEntropyMatrix(j,:);
end

end

