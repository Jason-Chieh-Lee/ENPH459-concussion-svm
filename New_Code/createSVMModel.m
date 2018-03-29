function [SVMModel] = createSVMModel(dataset,labels,svmMethod)
%CREATESVMMODEL_ Creates cross-validated SVM model based on loaded dataset, labels and
%method (either "fitcsvm" or "fitclinear")
%   Inputs: dataset - feature extraction matrix
%           labels - concussed/non-concussed label for each patient
%           method - which Matlab SVM model method to use. This is between
%           "fitcsvm" which is recommended for low-medium dimensional
%           parameters, and "fitclinear" which is recommended for high
%           dimensional parameters

if svmMethod == "fitcsvm"
    SVMModel = fitcsvm(dataset,labels,'Crossval','on','Standardize',true,'KernelFunction','RBF','KernelScale','auto'); %default kernel is RBF
elseif svmMethod == "fitclinear"
    SVMModel = fitclinear(dataset,labels);
end

SVMModel = SVMModel.Trained{1};

end

