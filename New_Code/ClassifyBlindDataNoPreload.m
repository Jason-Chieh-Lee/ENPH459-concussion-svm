createAndSaveFeatureMatrixForTraining;
createAndSaveBlindFeatureMatrix;

featureMatrixForTraining = load('featureMatrixForTraining.mat');
field = fieldnames(featureMatrixForTraining);
fieldName = field{1};
featureMatrixForTraining = featureMatrixForTraining.(fieldName);

blindFeatureMatrix = load('blindFeatureMatrix.mat');
field = fieldnames(blindFeatureMatrix);
fieldName = field{1};
blindFeatureMatrix = blindFeatureMatrix.(fieldName);

 
labelsForTraining = load('labelsForTraining.mat');
field = fieldnames(labelsForTraining);
fieldName = field{1};
labelsForTraining = labelsForTraining.(fieldName);
%% Testing of SVM Model below
tries = 1;

for i=1:tries
    [kFoldsvmModel, holdoutsvmModel, leaveoutsvmModel] = createSVMModel(featureMatrixForTraining,labelsForTraining,"fitcsvm");

    kfoldtestLabels = returnKfoldResults(kFoldsvmModel,blindFeatureMatrix);
    
    holdouttestLabels = predict(holdoutsvmModel,blindFeatureMatrix);

    leaveouttestLabels = returnLeaveOutResult(leaveoutsvmModel,blindFeatureMatrix);

end
