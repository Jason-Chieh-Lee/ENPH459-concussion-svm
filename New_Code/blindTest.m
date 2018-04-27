%directory = pwd;
%[fMatrix,labels] = featureExtraction(directory);
% "fitcsvm" or "fitclinear"
%% This section loads preprocessed labels and feature matrix. This is because this takes the longest
fMatrix = load('featureMatrix.mat');
field = fieldnames(fMatrix);
fieldName = field{1};
fMatrix = fMatrix.(fieldName);

testMatrix = load('ans.mat');
field = fieldnames(testMatrix);
fieldName = field{1};
testMatrix = testMatrix.(fieldName);

 
 labels = load('correctLabels.mat');
 field = fieldnames(labels);
 fieldName = field{1};
 labels = labels.(fieldName);
%% Testing of SVM Model below
%[kFoldsvmModel, holdoutsvmModel, leaveoutsvmModel] = createSVMModel(fMatrix,labels,"fitcsvm");
tries = 1;
accuracy = zeros(tries,3);

%label = predict(SVMModel,X)
for i=1:tries
    [kFoldsvmModel, holdoutsvmModel, leaveoutsvmModel] = createSVMModel(fMatrix,labels,"fitcsvm");

    kfoldtestLabels = returnKfoldResults(kFoldsvmModel,testMatrix);
    %kfoldAccuracy = getAccuracy(kfoldtestLabels,labels);
    
    %accuracy(i,1) = kfoldAccuracy;
    
    holdouttestLabels = predict(holdoutsvmModel,testMatrix);
    %holdoutAccuracy = getAccuracy(holdouttestLabels,labels);

    %accuracy(i,2) = holdoutAccuracy;
    
    leaveouttestLabels = returnLeaveOutResult(leaveoutsvmModel,testMatrix);
    %leaveoutAccuracy = getAccuracy(leaveouttestLabels,labels);
    
    %accuracy(i,3) = leaveoutAccuracy;

end

%avgKfoldAccuracy = sum(accuracy(:,1))/tries;
%avgHoldOutAccuracy = sum(accuracy(:,2))/tries;
%avgLeaveOutAccuracy = sum(accuracy(:,3))/tries;
