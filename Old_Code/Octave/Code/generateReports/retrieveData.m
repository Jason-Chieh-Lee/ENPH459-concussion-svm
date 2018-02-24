function subjectData = retrieveData(IDNameDBFile, dataDBFile)
%IDNameDBFile = 'C:/Users/Andrew/Documents/Work/EEGleWave/EEG Report Generation/trunk/Octave/data/Confidential Identification.xlsx'
%dataDBFile = 'C:/Users/Andrew/Documents/Work/EEGleWave/EEG Report Generation/trunk/Octave/data/SCAT3 results.xlsx'
% NOTE: requires Octave 'io' package
pkg load io
pkg load financial

if ~exist(IDNameDBFile, 'file')
  display('File does not exist.');
  return;
end
if ~exist(dataDBFile, 'file')
  display('File does not exist.');
  return;
end

% To do: check filetype for compatibility
%{
if ~fileIsValid(dataDBFile)
  display('Invalid file type.');
  return;
end
if ~fileIsValid(IDNameDBFile)
  display('Invalid file type.');
  return;
end
%}

% Used to get subject names from IDs
[numarr0, txtarr0, rawarr0, limits0] = xlsread(IDNameDBFile);

% Get data based on subject IDs
[numarr1, txtarr1, rawarr1, limits1] = xlsread(dataDBFile);		% 1st sheet has regular SCAT3 results
[numarr2, txtarr2, rawarr2, limits2] = xlsread(dataDBFile, 2);	% 2nd sheet has child SCAT3 results
[numarr3, txtarr3, rawarr3, limits3] = xlsread(dataDBFile, 4);	% 4th sheet has concussion classification results

% ID File
titleIdx0 = find(strcmp("Identifier", txtarr0) == 1);  % Find start of data

% SCAT3
titleIdx1 = find(strcmp("Identifier", txtarr1) == 1);  % Find start of data

% Concussed Summary
titleIdx3 = find(strcmp('Identifier', txtarr3) == 1);  % Find start of data

numRows0 = size(rawarr0,1);
numCols0 = size(rawarr0,2);

numRows1 = size(numarr1,1);
numCols1 = size(rawarr1,2);

numRows2 = size(numarr2,1);
numCols2 = size(rawarr2,2);

numRows3 = size(numarr3,1);
numCols3 = size(rawarr3,2);

numDataRows = numRows1 + numRows2;

% Name and ID data
IDNameData = cell(numDataRows,1);
firstNameData = cell(numDataRows,1);
lastNameData = cell(numDataRows,1);
parentFirstNameData = cell(numDataRows,1);
parentLastNameData = cell(numDataRows,1);
DOBData = cell(numDataRows,1);
phoneData = cell(numDataRows,1);

% Subject data
IDData = cell(numDataRows,1);
divisionData = cell(numDataRows,1); 
ageData = cell(numDataRows,1);
genderData = cell(numDataRows,1);
dateData = cell(numDataRows,1);
scanTypeData = cell(numDataRows,1);
handednessData = cell(numDataRows,1);
concussionsData = cell(numDataRows,1);
mostRecentConcData = cell(numDataRows,1);
numSymptomsData = cell(numDataRows,1);
severityScoreData = cell(numDataRows,1);
orientationData = cell(numDataRows,1);
orientationTotalData = cell(numDataRows,1);
immMemData = cell(numDataRows,1);
concentrationData = cell(numDataRows,1);
concentrationTotalData = cell(numDataRows,1);
delayedRecallData = cell(numDataRows,1);
SACData = cell(numDataRows,1);
BESSData = cell(numDataRows,1);
tandemGaitData = cell(numDataRows,1);
coordinationData = cell(numDataRows,1);

% For concussed data
concussedIDData = cell(numRows3,1);
concussedClassData = cell(numRows3,1);

% Convert empty cells to 'N/A'
emptyCellIdx0 = find(cellfun(@isempty,rawarr0));
emptyCellIdx1 = find(cellfun(@isempty,rawarr1));
emptyCellIdx2 = find(cellfun(@isempty,rawarr2));
rawarr0(emptyCellIdx0) = {'N/A'};
rawarr1(emptyCellIdx1) = {'N/A'};
rawarr2(emptyCellIdx2) = {'N/A'};

for n = 1:numRows1
	i = n + titleIdx1; % shift for correcting indices
	IDData(n) = rawarr1(i,1){};
	divisionData(n) = strrep(rawarr1(i,2){}, ' ', '~');
	ageData(n) = num2str(rawarr1(i,3){});
	genderData(n) = rawarr1(i,4){};
	
	if isnumeric(rawarr1(i,5){})
		dateData(n) = datestr(x2mdate(rawarr1(i,5){}), "mmm~dd,~yyyy");
	else
		dateData(n) = strrep(rawarr1(i,5){}, ' ', '~');
	end
	
	scanType = IDData(n){}(4:6);
	% Determine scan type
	if (strcmpi(scanType(3), 'B'))
		scanType = 'Baseline';
	elseif (strcmpi(scanType(3), 'C'))
		scanType = cstrcat('Concussed Follow-up ', scanType(1:2));
	end
	scanTypeData(n) = strrep(scanType, ' ', '~');	
	
	handednessData(n) = num2str(rawarr1(i,7){});
	concussionsData(n) = num2str(rawarr1(i,8){});
	
	if isnumeric(rawarr1(i,9){})
		if isempty(rawarr1(i,9){})
			mostRecentConcData(n) = 'N/A';
		else
			if (rawarr1(i,9){} > 3000) % Checks if there is only a year specified or an entire date (arbitrarily using the year 3000)
				mostRecentConcData(n) = datestr(x2mdate(rawarr1(i,9){}), "mmm~dd,~yyyy");
			else
				mostRecentConcData(n) = num2str(rawarr1(i,9){});
			end
		end
	else
		mostRecentConcData(n) = strrep(rawarr1(i,9){}, ' ', '~');
	end
	
	numSymptomsData(n) = num2str(rawarr1(i,40){});
	severityScoreData(n) = num2str(rawarr1(i,41){});
	orientationData(n) = num2str(rawarr1(i,44){});
	orientationTotalData(n) = '5';
	immMemData(n) = num2str(rawarr1(i,45){});
	concentrationData(n) = num2str(rawarr1(i,48){});
	concentrationTotalData(n) = '5';
	delayedRecallData(n) = num2str(rawarr1(i,59){});
	SACData(n) = num2str(rawarr1(i,60){});
	BESSData(n) = num2str(rawarr1(i,55){});
	tandemGaitData(n) = num2str(rawarr1(i,56){});
	coordinationData(n) = num2str(rawarr1(i,58){});
end

for n = 1:numRows2
	i = n + titleIdx1; % shift for correcting indices
	IDData(n + numRows1) = rawarr2(i,1){};
	divisionData(n + numRows1) = strrep(rawarr2(i,2){}, ' ', '~');
	ageData(n + numRows1) = num2str(rawarr2(i,3){});
	genderData(n + numRows1) = rawarr2(i,4){};
	
	if isnumeric(rawarr2(i,5){})
		dateData(n + numRows1) = datestr(x2mdate(rawarr2(i,5){}), "mmm~dd,~yyyy");
	else
		dateData(n + numRows1) = strrep(rawarr2(i,5){}, ' ', '~');
	end
	
	scanType = IDData(n + numRows1){}(4:6);
	% Determine scan type
	if (strcmpi(scanType(3), 'B'))
		scanType = 'Baseline';
	elseif (strcmpi(scanType(3), 'C'))
		scanType = cstrcat('Concussed Follow-up ', scanType(1:2));
	end
	scanTypeData(n + numRows1) = strrep(scanType, ' ', '~');	
	
	handednessData(n + numRows1) = num2str(rawarr2(i,7){});
	concussionsData(n + numRows1) = num2str(rawarr2(i,8){});
	
	if isnumeric(rawarr2(i,9){})
		if isempty(rawarr2(i,9){})
			mostRecentConcData(n + numRows1) = 'N/A';
		else
			if (rawarr2(i,9){} > 3000) % Checks if there is only a year specified or an entire date (arbitrarily using the year 3000)
				mostRecentConcData(n + numRows1) = datestr(x2mdate(rawarr2(i,9){}), "mmm~dd,~yyyy");
			else
				mostRecentConcData(n + numRows1) = num2str(rawarr2(i,9){});
			end
		end
	else
		mostRecentConcData(n + numRows1) = strrep(rawarr2(i,9){}, ' ', '~');
	end
	
	numSymptomsData(n + numRows1) = num2str(rawarr2(i,38){});
	severityScoreData(n + numRows1) = num2str(rawarr2(i,39){});
	orientationData(n + numRows1) = num2str(rawarr2(i,66){});
	orientationTotalData(n + numRows1) = '4';
	immMemData(n + numRows1) = num2str(rawarr2(i,67){});
	concentrationData(n + numRows1) = num2str(rawarr2(i,70){});
	concentrationTotalData(n + numRows1) = '6';
	delayedRecallData(n + numRows1) = num2str(rawarr2(i,80){});
	SACData(n + numRows1) = num2str(rawarr2(i,81){});
	BESSData(n + numRows1) = num2str(rawarr2(i,76){});
	tandemGaitData(n + numRows1) = num2str(rawarr2(i,77){});
	coordinationData(n + numRows1) = num2str(rawarr2(i,79){});
end

% Populate cell of ID/Names data
rawarr0 = sortrows(rawarr0(1+titleIdx0:size(rawarr0,1),:),1);

for n = 1:numDataRows
	IDNameData(n) = rawarr0(n,1){};
	firstNameData(n) = strrep(rawarr0(n,2){}, ' ', '~');
	lastNameData(n) = strrep(rawarr0(n,3){}, ' ', '~');
	parentFirstNameData(n) = strrep(rawarr0(n,4){}, ' ', '~');
	parentLastNameData(n) = strrep(rawarr0(n,5){}, ' ', '~');
	DOBData(n) = datestr(x2mdate(rawarr0(n,7){}), "mmm~dd,~yyyy");
	phoneData(n) = num2str(rawarr0(n,9){});
end

SubjectIDData = {IDNameData'{}; firstNameData'{}; lastNameData'{}; parentFirstNameData'{}; parentLastNameData'{}; DOBData'{}; phoneData'{}}';

% Find matches, fixes offsets due to missing data and ensure data is sorted properly
for i = 1:numDataRows
    idx = strcmp(IDData(i), SubjectIDData);
    idxMatch = find(idx == 1);
    
    firstNameData(i) = SubjectIDData{idxMatch, 2};
	lastNameData(i) = SubjectIDData{idxMatch, 3};
	parentFirstNameData(i) = SubjectIDData{idxMatch, 4};
  
	parentLastNameData(i) = SubjectIDData{idxMatch, 5};
	DOBData(i) = SubjectIDData{idxMatch, 6};
	phoneData(i) = SubjectIDData{idxMatch, 7};
end

% Populate cell of concussed data
rawarr3 = sortrows(rawarr3(1+titleIdx3:size(rawarr3,1),:),1);
for n = 1:numRows3
    concussedIDData(n) = rawarr3(n,1){};
    concussedClassData(n) = rawarr3(n,2){};
end

concussedData = {concussedIDData'{}; concussedClassData'{}}';
isConcussedData = cell(numDataRows, 1);

% Find matches, fixes offsets due to missing data and ensure data is sorted properly
% Stores concussion class in isConcussedData or stores '0' if subject ID is missing
for i = 1:numDataRows
    idx = strcmp(IDData(i), concussedData);
    idxMatch = find(idx == 1);
    
    if (sum(idxMatch) > 0)
        isConcussedData(i) = num2str(concussedData{idxMatch, 2});
    else
        isConcussedData(i) = '0';
    end
end

% Possibly need to replace whitespace with '~' before translating data to command arguments
%strrep(..., ' ', '~');

subjectData = {IDData'{}; firstNameData'{}; lastNameData'{}; parentFirstNameData'{}; parentLastNameData'{}; divisionData'{}; ageData'{}; genderData'{}; dateData'{}; scanTypeData'{}; handednessData'{}; concussionsData'{}; mostRecentConcData'{}; isConcussedData'{}; numSymptomsData'{}; severityScoreData'{}; orientationData'{}; orientationTotalData'{}; immMemData'{}; concentrationData'{}; concentrationTotalData'{}; delayedRecallData'{}; SACData'{}; BESSData'{}; tandemGaitData'{}; coordinationData'{}; phoneData'{}}';
subjectData = sortrows(subjectData, 1);  % Sort according to the IDData row

end