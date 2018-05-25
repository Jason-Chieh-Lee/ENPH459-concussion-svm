%directory = pwd;
%[fMatrix,labels] = featureExtraction(directory);
% "fitcsvm" or "fitclinear"

%% This section loads preprocessed labels and feature matrix. This is because this takes the longest
featureMatrix = load('featureMatrix.mat');
field = fieldnames(featureMatrix);
fieldName = field{1};
featureMatrix = featureMatrix.(fieldName);

testMatrix = load('blindTestFeatures.mat');
field = fieldnames(testMatrix);
fieldName = field{1};
testMatrix = testMatrix.(fieldName);

 
labels = load('correctLabels.mat');
field = fieldnames(labels);
fieldName = field{1};
labels = labels.(fieldName);
%% Testing of SVM Model below
tries = 1;
accuracy = zeros(tries,3);

for i=1:tries
    [kFoldsvmModel, holdoutsvmModel, leaveoutsvmModel] = createSVMModel(featureMatrix,labels,"fitcsvm");

    kfoldtestLabels = returnKfoldResults(kFoldsvmModel,testMatrix);
    
    holdouttestLabels = predict(holdoutsvmModel,testMatrix);

    leaveouttestLabels = returnLeaveOutResult(leaveoutsvmModel,testMatrix);

end
