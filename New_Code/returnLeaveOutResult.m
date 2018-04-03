function [prediction] = returnLeaveOutResult(leaveOutObject,predictionData)
%RETURNLEAVEOUTRESULTS Returns averaged predictions of kfold cross-validated
%SVM models
%   Inputs: leaveOutObject: MATLAB SVM object containing all the trained SVM 
%           models
%           predictionData: data used for predictions
%
%   Outputs: prediction: result taken as the majority prediction of all the
%            SVM models

[rowSize,colSize] = size(leaveOutObject.Trained);
[dataRow,dataCol] = size(predictionData);
predictions = zeros(dataRow,rowSize);
prediction = zeros(dataRow,1);

for i = 1:rowSize
    predictions(:,i) = predict(leaveOutObject.Trained{i},predictionData);
end

for i = 1:dataRow
    prediction(i,1) = mode(predictions(i,:));
end
end

