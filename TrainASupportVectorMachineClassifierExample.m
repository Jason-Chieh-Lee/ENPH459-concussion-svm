%% Train a Support Vector Machine Classifier
%%
% Load Fisher's iris data set. Remove the sepal lengths and widths, and all
% observed setosa irises.

% Copyright 2015 The MathWorks, Inc.

load fisheriris
inds = ~strcmp(species,'setosa');
% Ignore all the 0s, get all the 1s from inds for what we want from meas,
% and columns 3 to 4 for meas.
X = meas(inds,3:4);
% Same here except just need everything not setosa
y = species(inds);
%%
% Train an SVM classifier using the processed data set.
SVMModel = fitcsvm(X,y)
%%
% The Command Window shows that |SVMModel| is a trained |ClassificationSVM|
% classifier and a property list.  Display the
% properties of |SVMModel|, for example, to determine the class order, by using
% dot notation.
classOrder = SVMModel.ClassNames
%%
% The first class (|'versicolor'|) is the negative class, and the second
% (|'virginica'|) is the positive class.  You can change the class order
% during training by using the |'ClassNames'| name-value pair argument.
%%
% Plot a scatter diagram of the data and circle the support vectors.
sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('versicolor','virginica','Support Vector')
hold off
%%
% The support vectors are observations that occur on or beyond their
% estimated class boundaries.
%%
% You can adjust the boundaries (and therefore the number of support
% vectors) by setting a box constraint during training using the
% |'BoxConstraint'| name-value pair argument.