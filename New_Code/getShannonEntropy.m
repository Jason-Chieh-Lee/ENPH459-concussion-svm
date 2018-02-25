function shannonEntropyMatrix = getShannonEntropy(eegMatrix)
%GETSHANNONENTROPY Takes in matrix of EEG data and returns a 1x27 matrix
% with Shannon Entropy of each channel.
%   Input: eegMatrix - a nx27 matrix of the eeg data for each channel
%   Output: shannonEntropyMatrix - a 1x27 matrix of the shannon entropy of
%   each channel. This can then be added to the feature matrix.

[rowSize, colSize] = size(eegMatrix);
shannonEntropyMatrix = zeros(1,colSize);

% Get Shannon entropy of each channel (column)
for col = 1:colSize
    shannonEntropyMatrix(1,col) = wentropy(eegMatrix(1,col),'shannon');
end

end

