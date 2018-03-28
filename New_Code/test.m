%{
eegStruct = load('BN.mat');
field = fieldnames(eegStruct);
fieldName = field{1};
eegMatrix = eegStruct.(fieldName);
matrix = [1 1;1 1;2 1;2 1;3 2;3 3];
[shannonmat, uniquesymbols, probmatrix] = getShannonEntropy(eegMatrix);
%[shannonmat, uniquesymbols, probmatrix] = getShannonEntropy(matrix)
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
