function generateReports(IDNameDBFile, dataDBFile, dataPath, reportsPath, plotType)
%IDNameDBFile = '/home/eeglewave/Documents/Report Generation/Databases/SFH/Confidential Identification.xlsx'
%dataDBFile = '/home/eeglewave/Documents/Report Generation/Databases/SFH/SCAT3 and VOMS.xlsx'
%dataPath = 'C:\Users\Andrew\Documents\Work\EEGleWave\EEG Data'
%reportsPath = 'C:\Users\Andrew\Documents\Work\EEGleWave\Reports'

page_screen_output(0);
page_output_immediately(1);

[dirID, fnameID, extID] = fileparts(IDNameDBFile);
[dirData, fnameData, extData] = fileparts(dataDBFile);

if (~exist(IDNameDBFile, 'file'))
  fprintf('Error: File %s%s does not exist.\n', fnameID, extID);
  return;
end

if (~exist(dataDBFile, 'file'))
  fprintf('Error: File %s%s does not exist.\n', fnameData, extData);
  return;
end

if (nargin < 5)
  plotType = 'scalp';
end

plotType = tolower(plotType);

if (~strcmpi(plotType, 'scalp') && ~strcmpi(plotType, 'scatter'))
  plotType = 'scalp';
end

%% Retrieve data from database
fprintf('\n');
fprintf('Report generation started.\n');

%% Check if .mat files exist
if ~exist(strcat(dataPath, '/MAT'), 'dir')
	fprintf('Error: %s/MAT directory not found.\n', dataPath);
	fprintf('Please run the mff2mat.m script in MATLAB to create the appropriate .mat files.\n');
	fprintf('Report generation cancelled.\n');
	return;
end

fprintf('Retrieving and parsing data... ');
subjectData = retrieveData(IDNameDBFile, dataDBFile);
fprintf('Done.\n');

%% Compile the PDF report from the latex file
fprintf('Compiling PDF reports...\n');
compilePDF(subjectData, dataPath, reportsPath, plotType);
fprintf('Done compiling.\n');

fprintf('Report generation completed.\n');
fprintf('\n');

end