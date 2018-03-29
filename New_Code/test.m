%{
matrix = [1 1;1 1;2 1;2 1;3 2;3 3];
%[shannonmat, uniquesymbols, probmatrix] = getShannonEntropy(eegMatrix);
shannonmat= getShannonEntropy(matrix, 1)
%}

%% formatFeaturesForTraining Testing
%{
testMatrix = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27;
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27;
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27;
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27;]

formattedMatrix = formatFeaturesForTraining(testMatrix);
%}
%% getAccuracy Testing
% have 5 mistakes out of 25, so classification accuracy of 80% should be
% returned
%{
svmResults = [1;1;0;1;1;1;1;0;1;1;0;1;1;1;1;0;0;0;1;1;1;1;1;0;1];
correctResults = [1;1;0;1;1;0;1;1;1;1;0;1;1;1;1;0;0;1;1;1;1;0;1;1;1];

accuracy = getAccuracy(svmResults,correctResults)
%}
%% Testing feature extraction label making
%{
concussedFilenames = [1;1;1;1;1;1;1;1;1;1]; %10 entries
controlFilenames = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];%15 entries
labels = ones(length(concussedFilenames)+length(controlFilenames),1);
labels(length(concussedFilenames)+1:length(labels), 1) = 0;% labels should have 10 1s and 15 0s
%}

directory = pwd;
[fMatrix,labels] = featureExtraction(directory);
% "fitcsvm" or "fitclinear"
svmModel = createSVMModel(fMatrix,labels,"fitcsvm");
%label = predict(SVMModel,X)
testLabels = predict(svmModel,fMatrix);
accuracy = getAccuracy(testLabels,labels);
