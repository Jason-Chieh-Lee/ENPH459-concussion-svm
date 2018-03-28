%Requires: Folders names "Concussed" and "Controls" in the given directory
%corresponding to EEG Data for conccussed patients and control patients
%respectively.

function [featureMatrix,labels] = featureExtraction(directory)

%directory = 'C:\Users\Dylan\Desktop\New folder\Capstone Training Data';

featureMatrix = zeros(1, 891); %33x27 features extracted for each patient

%Extract .mat files corresponding to concussed patients 
concussedDirectory = dir(strcat(directory, '\Concussed\*\*.mat'));
concussedFilenames = {concussedDirectory.name};

%Append concussed features to feature matrix
for k = 1:length(concussedFilenames)
    %strcat(directory,'\Concussed\',concussedFilenames{k})
    %7==exists(strcat(directory,'\Concussed\',concussedFilenames{k}))
    eegMat = load(strcat(directory,'\Concussed\',concussedFilenames{k}));
    features = extractFeatures(eegMat);
    featureMatrix(k,:) = features(:)';
end
    

%Extract .mat files corresponding to non-concussed patients
controlDirectory = dir(strcat(directory, '\Controls\*\*.mat'));
controlFilenames = {controlDirector.name};

%Append control features to control matrix
for j=1:length(controlFilenames)
    k = k + 1;
    eegMat = load(strcat(directory,'\Controls\',controlFilenames{j}));
    features = extractFeatures(eegMat);
    featureMatrix(k,:) = features(:)';    
end

labels = ones(length(concussedFilenames)+length(controlFilenames),1);
labels(length(concussedFilenames)+1:length(labels), 1) = 0;
end