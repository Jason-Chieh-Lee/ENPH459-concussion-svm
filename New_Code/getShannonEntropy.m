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

% Get Shannon entropy of each channel (column)
for col = 1:colSize
    roundedMatrix = round(eegMatrix(:,col),decimalPlace);
    % Get all the unique Symbols in the signal
    uniqueSymbols = unique(roundedMatrix);
    [uniqueRowSize, uniqueColSize] = size(uniqueSymbols);
    
    %Create a Matrix to store probability for each unique Symbol
    probMatrix = zeros(1,uniqueRowSize);
    
    %For each unique symbol, find the number of times it's found in the
    %channel
    for symbolIndex = 1:uniqueRowSize
        symbol = uniqueSymbols(symbolIndex);
        
        probMatrix(1, symbolIndex) = sum(roundedMatrix(:,1)==symbol);
        
    end
    
    % Calculate Shannon Entropy for given column
    probMatrix = probMatrix./rowSize;
    for i = 1:uniqueRowSize
        shannonEntropyMatrix(1,col) = shannonEntropyMatrix(1,col)+(-probMatrix(1,i))*(log(probMatrix(1,i)));
    end
end

end