function [accuracyRate] = getAccuracy(svmLabels,actualLabels)
%GETACCURACY Summary of this function goes here
%   Detailed explanation goes here

[rowSize, colSize] = size(svmLabels);
missclass = 0;

for row = 1:rowSize
    if svmLabels(row,1)~=actualLabels(row,1)
        missclass = missclass+1;
    end
end

accuracyRate = (rowSize-missclass)/rowSize;

end