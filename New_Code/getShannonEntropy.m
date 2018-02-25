function shannonEntropyMatrix = getShannonEntropy(eegMatrix)
%GETSHANNONENTROPY Summary of this function goes here
%   Detailed explanation goes here
[rowSize, colSize] = size(eegMatrix);
shannonEntropyMatrix = zeros(1,colSize);

for col = 1:colSize
    shannonEntropyMatrix(1,col) = wentropy(eegMatrix(1,col),'shannon');
end

end

