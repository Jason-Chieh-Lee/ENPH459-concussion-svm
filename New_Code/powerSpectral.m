% Author: Dylan Patrick Whitney
% Date: March 25, 2018
% Purpose: Returns a 7x27 feature matrix given a set of cleaned and
% interpolated EEG Data in .Mat format.
% Params: eegMat: EEG Data in .Mat format
% featureMatrix: 7x27 feature matrix. The 7 features in order are: mean
% theta power, mean alpha power, mean beta power, mean gamma power, alphaPower/thetaPower, betaPower/alphaPower, gammaPower/betaPower.

function [featureMatrix] = powerSpectral(eegMat)

samplingFrequency = 250; % Hz 
numRows = size(eegMat,1);
frequencyIncrement = samplingFrequency/numRows;

featureMatrix = [];

% For each of the 27 channels, compute the discrete fourier transform, find
% the frequency bands that correspond to brain waves (i.e Alpha, Beta,
% Gamma, Theta), and compute the mean absolute powers
for i = 1:27
    y = (abs(fft(eegMat(:,i))).^2)/numRows;
    %f = (0:length(y)-1)*(250/length(y));
    %plot(f(1:15000),y(1:15000))
    currentFrequency = frequencyIncrement;
    
    %theta = 4-8Hz
    theta = [];
    for k = 1:numRows
        
        currentFrequency = currentFrequency + frequencyIncrement;
        if currentFrequency < 4
            continue
        end    
        theta(k) = y(k);
        
        if currentFrequency >= 8
            break
        end        
    end
    
    theta = theta(theta~=0);
    thetaPower = (sum(theta))/length(theta);
    featureMatrix(1,i) = thetaPower;
    
    alphaPower = meanPower(y, frequencyIncrement, numRows, 8, 12);
    
    featureMatrix(2,i) = alphaPower;
    
    betaPower = meanPower(y, frequencyIncrement, numRows, 12, 30);
    featureMatrix(3,i) = betaPower;
    
    gammaPower = meanPower(y, frequencyIncrement, numRows, 30,50);
    featureMatrix(4,i) = gammaPower;
    
    % Compute the ratios of absolute power in adjacent frequency bands
    featureMatrix(5,i) = alphaPower/thetaPower;
    featureMatrix(6,i) = betaPower/alphaPower;
    featureMatrix(7,i) = gammaPower/betaPower;

end

end