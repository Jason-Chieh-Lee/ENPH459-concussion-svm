%Requires: Folders names "Concussed" and "Controls" in the given directory
%corresponding to EEG Data for conccussed patients and control patients
%respectively.

function [featureMatrix,labels] = blindTestFeatureExtraction(directory)

%directory = 'C:\Users\Dylan\Desktop\New folder\Capstone Training Data';

%Extract .mat files corresponding to concussed patients 
concussedDirectory = dir(strcat(directory, '\Blind\*.mat'));
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
end