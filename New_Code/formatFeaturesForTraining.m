function [formattedFeatureRow] = formatFeaturesForTraining(featureMatrix)
%FORMATFEATURESFORTRAINING Formats the features of a single subject to a
%single row required for SVM training.
%   Input: featureMatrix - the numFeatures x 27channel feature matrix of a
%   single subject.
%   Output: formattedFeatureRow - the one row equivalent of each channel's
%   features transposed.

[featureRowSize, featureColSize] = size(featureMatrix);
formattedFeatureRow = zeros(1,featureRowSize*featureColSize);
startCol = 1;
for col =1:featureColSize
    formattedFeatureRow(1,startCol:col*featureRowSize) = transpose(featureMatrix(:,col));
    startCol = startCol+featureRowSize;
end

end

