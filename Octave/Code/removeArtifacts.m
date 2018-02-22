function [workingData, percentRemoved] = removeArtifacts(file, numWindows)

page_screen_output(0);
page_output_immediately(1);

if (nargin != 2)
	error('Too few input arguments. Usage: cleanedData = removeArtifacts(dataFile, numWindows)');
end

% NOTE: requires Octave 'signal' package (which requires the 'control' package)
pkg load signal

load(file); % Contains 'data' variable
workingData = data;

sampDuration = 6; % minutes
fs_ref = 250;

numDataPoints = length(data); % possibly change so that we can cut off garbage data near beginning and end of sampling
numOfsamples_to = numDataPoints - mod(numDataPoints,sampDuration*fs_ref*60); % used to find sampling freq

fs = numOfsamples_to/(sampDuration*60);
if (fs == 0)
	fs = fs_ref;
end

t_end = numOfsamples_to/fs;

numRows = size(data,1);
if (numRows == 65)
	nElec = numRows - 1;
else
	nElec = numRows;
end

% Filter data
order    = 2;
fcutlow  = 0.1;
fcuthigh = 40;
[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2));
for n = 1:nElec
	workingData(n,:)   = filtfilt(b,a,data(n,:));
end

threshold = max(max(abs(std(workingData))));	% Threshold value used for window rejection

%numWindows = 10;				% Number of windows to divide the data set into
windowSize = 1/numWindows;		% Size of windows used to divide the data set, expressed as a fraction of the data set (0.1 to 1);
numSamplesPerWindow = ceil(windowSize*numDataPoints);
idxData = ones(numWindows, 2);	% Store window indices

% Find window indices
for i = 1:numWindows
	startIdx = (i - 1)*numSamplesPerWindow + 1;
	endIdx = i*numSamplesPerWindow;
	
	if (endIdx > numDataPoints)
		endIdx = numDataPoints;
	end
	
	idxData(i,:) = [startIdx endIdx];
end

% Remove artifacts
% Start from the end so we don't have to deal with data set length changing after removal
fprintf('Removing artifacts...\n');
for i = numWindows:-1:1
	% Find if any absolute data values are > threshold
	if any(find(abs(workingData(:,idxData(i,1):idxData(i,2))) > threshold))
		workingData(:,idxData(i,1):idxData(i,2)) = [];
		%data(:,idxData(i,1):idxData(i,2)) = [];
		%fprintf('\tFound artifacts: indices %d to %d removed.\n', idxData(i,1), idxData(i,2));
	end
end

if isempty(workingData)
	error('Data set is empty. Try increasing the threshold value.');
	fprintf('Operation cancelled.\n');
	return;
end

percentRemoved = 100*(1 - length(workingData)/numDataPoints);

fprintf('Removed %.2f%% of the data.\n', percentRemoved);

fprintf('Operation finished.\n');

end