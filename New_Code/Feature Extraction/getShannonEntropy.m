function [shannonEntropyMatrix] = getShannonEntropy(eegMatrix, decimalPlace)
%GETSHANNONENTROPY Takes in matrix of EEG data and returns a 1x27 matrix
% with Shannon Entropy of each channel.
%   Input: eegMatrix - a nx27 matrix of the eeg data for each channel
%          decimalPlace - how many digits to the right to round the signals
%          to, without rounding there are too many distinct signals
%   Output: shannonEntropyMatrix - a 1x27 matrix of the shannon entropy of
%   each channel. This can then be added to the feature matrix.

[rowSize, colSize] = size(eegMatrix);
shannonEntropyMatrix = zeros(1,colSize);

for col = 1:colSize
    roundedCol= round(eegMatrix(:,col),decimalPlace);
    freqTable = tabulate(roundedCol);
    freqTable(:,3) = freqTable(:,3)./100;
    
    [freqRow, freqCol] = size(freqTable);
    for i =1:freqRow
        shannonEntropyMatrix(1,col) = shannonEntropyMatrix(1,col)+(-freqTable(i,3))*(log(freqTable(i,3)));
    end
end

end