% Author: Dylan Patrick Whitney
% Date: March 25, 2018
% Purpose: To compute the mean absolute power given a frequency band
% Params: Inputs: fourierTransform: discrete fourier transform of time series data
%                                   frequencyIncrement: the change in frequency with each
%                                   change of array index
%                 numRows: number of rows in the feature matrix
%                 startFrequency: starting frequency of the frequency band
%                 endFrequency: ending frequency of the frequency band
%         Output: power: the mean absolute power for the given frequency
%                        band

function power = meanPower(fourierTransform, frequencyIncrement, numRows, startFrequency, endFrequency)

currentFrequency = frequencyIncrement;

frequencyBand = [];
for k = 1:numRows
        
    currentFrequency = currentFrequency + frequencyIncrement;
    if currentFrequency < startFrequency
        continue
    end    
    frequencyBand(k) = fourierTransform(k);
        
    if currentFrequency > endFrequency
        break
    end        
end
    
frequencyBand = frequencyBand(frequencyBand~=0);
power = (sum(abs(frequencyBand).^2))/numRows;

end