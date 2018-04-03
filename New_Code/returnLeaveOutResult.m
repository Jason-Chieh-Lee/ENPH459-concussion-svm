function [prediction] = returnLeaveOutResult(leaveOutObject,trainingData)
%RETURNKFOLDRESULTS Summary of this function goes here
%   Detailed explanation goes here

[rowSize,colSize] = size(leaveOutObject.Trained);
[dataRow,dataCol] = size(trainingData);
predictions = zeros(dataRow,rowSize);
prediction = zeros(dataRow,1);

for i = 1:rowSize
    predictions(:,i) = predict(leaveOutObject.Trained{i},trainingData);
end

for i = 1:dataRow
    prediction(i,1) = mode(predictions(i,:));
end
end

