%directory = pwd;
%[fMatrix,labels] = featureExtraction(directory);
% "fitcsvm" or "fitclinear"
%% This section loads preprocessed labels and feature matrix. This is because this takes the longest
fMatrix = load('featureMatrix.mat');
field = fieldnames(fMatrix);
fieldName = field{1};
fMatrix = fMatrix.(fieldName);

labels = load('correctLabels.mat');
field = fieldnames(labels);
fieldName = field{1};
labels = labels.(fieldName);
%% Testing of SVM Model below
svmModel = createSVMModel(fMatrix,labels,"fitcsvm");

%label = predict(SVMModel,X)
testLabels = predict(svmModel,fMatrix);
accuracy = getAccuracy(testLabels,labels);