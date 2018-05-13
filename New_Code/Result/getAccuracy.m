function [accuracyRate] = getAccuracy(svmLabels,actualLabels)
%GETACCURACY Returns accuracy of SVM predictions
%   Inputs: svmLabels: predicted labels output by SVM
%           actualLabels: actual correct labels confirmed by doctors
%   Outputs: accuracyRate: the % of labels that were predicted correctly

[rowSize, colSize] = size(svmLabels);
missclass = 0;

for row = 1:rowSize
    if svmLabels(row,1)~=actualLabels(row,1)
        missclass = missclass+1;
    end
end

accuracyRate = (rowSize-missclass)/rowSize;

end