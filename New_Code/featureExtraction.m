%Requires: Folders names "Concussed" and "Controls" in the given directory
%corresponding to EEG Data for conccussed patients and control patients
%respectively.

function [featureMatrix,labels] = featureExtraction(directory)

%directory = 'C:\Users\Dylan\Desktop\New folder\Capstone Training Data';

%Extract .mat files corresponding to concussed patients 
concussedDirectory = dir(strcat(directory, '\Concussed\*\*.mat'));
concussedFilenames = {concussedDirectory.name};

concussedFoldernames = {concussedDirectory.folder};

%Extract Folder names from Concussed folder
%dirFlags = [concussedDirectory.isdir];
%subfolders = concussedDirectory(dirFlags);


%Append concussed features to feature matrix
for k = 1:length(concussedFilenames)
    %eegMat = load(strcat(concussedFoldernames{k},'\',concussedFilenames{k}));
    features = extractFeatures(strcat(concussedFoldernames{k},'\',concussedFilenames{k}));
    featureMatrix(k,:) = features(:)';
end
    

%Extract .mat files corresponding to non-concussed patients
controlDirectory = dir(strcat(directory, '\Controls\*\*.mat'));
controlFilenames = {controlDirectory.name};
controlFoldernames = {controlDirectory.folder};

%Append control features to control matrix
for j=1:length(controlFilenames)
    k = k + 1;
    features = extractFeatures(strcat(controlFoldernames{j}, '\', controlFilenames{j}));
    featureMatrix(k,:) = features(:)';    
end

labels = ones(length(concussedFilenames)+length(controlFilenames),1);
labels(length(concussedFilenames)+1:length(labels), 1) = 0;
end