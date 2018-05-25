directory = pwd;
[featureMatrixForTraining, labelsForTraining] = featureExtraction(directory);

save('featureMatrixForTraining', 'featureMatrixForTraining');
save('labelsForTraining', 'labelsForTraining');