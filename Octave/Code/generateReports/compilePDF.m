function compilePDF(subjectData, dataPath, reportsPath, plotType)

%% Read data
IDData = subjectData(:,1)
firstNameData = subjectData(:,2);
lastNameData = subjectData(:,3);
parentFirstNameData = subjectData(:,4);
parentLastNameData = subjectData(:,5);
divisionData = subjectData(:,6);
ageData = subjectData(:,7);
genderData = subjectData(:,8);
dateData = subjectData(:,9);
scanTypeData = subjectData(:,10);
handednessData = subjectData(:,11);
concussionsData = subjectData(:,12);
mostRecentConcData = subjectData(:,13);
isConcussedData = subjectData(:,14);
numSymptomsData = subjectData(:,15);
severityScoreData = subjectData(:,16);
orientationData = subjectData(:,17);
orientationTotalData = subjectData(:,18);
immMemData = subjectData(:,19);
concentrationData = subjectData(:,20);
concentrationTotalData = subjectData(:,21);
delayedRecallData = subjectData(:,22);
SACData = subjectData(:,23);
BESSData = subjectData(:,24);
tandemGaitData = subjectData(:,25);
coordinationData = subjectData(:,26);
phoneData = subjectData(:,27);

if ~exist(reportsPath, 'dir')
	mkdir(reportsPath);
end

%% Prompt the user to enter subjects
% See the initializeData MATLAB script for further comments
fprintf('\n\t');
fprintf('Enter the subject IDs to be processed (separated by commas). Use colons (:) for ranges. Leave blank to process all subjects:');
fprintf('\n\t');
choice = input('','s');
if (~isempty(choice))
  choice = strrep(choice, ' ', '');   % Remove all whitespace
  choice = strsplit(choice, ',');		% Split subjects
	choice = unique(choice);			% Remove duplicates
    numRanges = length(choice);
	rangeCount = 0;
	totalSubjects = 0;
	ranges = {};
	subjects = {};
	
	for n = 1:numRanges
		rangeChoice = strsplit(choice{n}, ':');
		
		if (length(rangeChoice) > 1)
			rangePrefix = rangeChoice{1}(1:6);
			start = str2num(rangeChoice{1}(end-3:end));
			stop = str2num(rangeChoice{2}(end-3:end));
			
			% Swap values if start is bigger
			if (start > stop)
				dummy = start;
				start = stop;
				stop = dummy;
			end
			
			% Populate the range
			rangeSize = stop - start + 1;
			range = cell(rangeSize, 1);		
			for i = 1:rangeSize
				subjNum = start + i - 1;
				if (length(num2str(subjNum)) == 1)
					rangeNumString = strcat('000', num2str(subjNum));
				elseif (length(num2str(subjNum)) == 2)
					rangeNumString = strcat('00', num2str(subjNum));
				elseif (length(num2str(subjNum)) == 3)
					rangeNumString = strcat('0', num2str(subjNum));
				else
					rangeNumString = num2str(subjNum);
				end
				
				range(i) = strcat(rangePrefix, rangeNumString);
			end
			
			totalSubjects = totalSubjects + rangeSize;
			rangeCount = rangeCount + 1;
			ranges{rangeCount} = range;
		else
			subjects(n) = choice(n);
			totalSubjects = totalSubjects + 1;
		end
	end
	
	for n = 1:length(subjects)
		choiceSubjects(n) = subjects(n);
	end
	
	startRangeCount = length(subjects);
	runningRangeCount = 0;
	for n = 1:length(ranges)
		currentRange = ranges{n};
		for i = 1:length(currentRange)
			runningRangeCount = runningRangeCount + 1;
			choiceSubjects(startRangeCount + runningRangeCount) = currentRange(i);
		end
	end
	
	choiceSubjects = unique(choiceSubjects);
	
	subjChooseIdx = findCellIdx(IDData, choiceSubjects);
	numSubjects = length(subjChooseIdx);
	
	if isempty(subjChooseIdx)
		fprintf('\t');
		fprintf('No subjects found with those IDs.\n\n');
	end
else
    numSubjects = length(IDData);
	subjChooseIdx = 1:numSubjects;
end

%% Calculate fallback values for the scalp plot limits
% Uses these values if the scalp_limits.mat file cannot be found
if (~strcmpi(plotType, 'scatter'))
  for i = 1:numSubjects
    n = subjChooseIdx(i);
    subjectPath = strcat(dataPath, '/MAT/', IDData{n});
    PSDfile = strcat(subjectPath, '/PSD_data_single_scalp_plot.mat');
    
    if exist(PSDfile, 'file')
      PSDData = loadPSD(PSDfile);
      
      if (i == 1)
        PSD_limits_fallback = [min(PSDData) max(PSDData)];
      else
        if (min(PSDData) < PSD_limits_fallback(1))
          PSD_limits_fallback = [min(PSDData) PSD_limits_fallback(2)];
        end
        
        if (max(PSDData) > PSD_limits_fallback(2))
          PSD_limits_fallback = [PSD_limits_fallback(1) max(PSDData)];
        end
      end
    end
  end
end

%% Continue with report generation
for i = 1:numSubjects
	n = subjChooseIdx(i);
	fprintf('\n');
	fprintf('\tCreating report for subject %s...\n',IDData{n});

	%% Load EEG data
	subjectPath = strcat(dataPath, '/MAT/', IDData{n});
	dataFile = strcat(subjectPath, '/matlab.mat');
  
	if exist(dataFile, 'file')
		subjectReportPath = strcat(reportsPath, '/', IDData{n});
        if ~exist(subjectReportPath, 'dir')
            %printf('\t\tCreating directories... ');
            mkdir(strcat(reportsPath, '/', IDData{n}));
            %fprintf('Done.\n');
        end
		
    if (strcmpi(plotType, 'scatter'))
      scatterPlotImg = strcat(subjectPath, '/scatterplot.png');
      localScatterPlotImg = strcat(pwd, '/scatterplot.png');
      copyfile(scatterPlotImg, localScatterPlotImg);
    else
      PSDData = loadPSD(strcat(subjectPath, '/PSD_data_single_scalp_plot.mat'));
      scalpPlotDatapath = strcat(dataPath, '/MAT/ScalpPlotData');
      
      fprintf('\t\tGenerating scalp plot... ');
      %% Generate scalp plots
      generateScalpPlots(PSDData, scalpPlotDatapath, subjectReportPath, PSD_limits_fallback);
      fprintf('Done.\n');
		end
    
		%% Construct report generation command
		cmd = cstrcat("pdflatex -synctex=0 -interaction=batchmode -output-directory=", "\"", subjectReportPath, "\"", " -jobname=", IDData(n){});
		cmd = cstrcat(cmd, " ", "report.tex");                    % Compile .tex file
		cmd = cstrcat(cmd, " ", firstNameData{n});              % FirstName
		cmd = cstrcat(cmd, " ", lastNameData{n});               % LastName
		cmd = cstrcat(cmd, " ", parentFirstNameData{n});        % ParentFirstName
		cmd = cstrcat(cmd, " ", parentLastNameData{n});         % ParentLastName
		cmd = cstrcat(cmd, " ", IDData{n});                     % ID
		cmd = cstrcat(cmd, " ", handednessData{n});             % Handedness
		cmd = cstrcat(cmd, " ", concussionsData{n});   		  % PrevConcussions
		cmd = cstrcat(cmd, " ", mostRecentConcData{n});   	  % MostRecentConcussion
		cmd = cstrcat(cmd, " ", isConcussedData{n});   	      % isConcussed
		cmd = cstrcat(cmd, " ", divisionData{n});   			  % Division
		cmd = cstrcat(cmd, " ", genderData{n});                 % Gender
		cmd = cstrcat(cmd, " ", ageData{n});          		  % Age
		cmd = cstrcat(cmd, " ", dateData{n});          		  % DOS
		cmd = cstrcat(cmd, " ", scanTypeData{n});               % ScanType
		cmd = cstrcat(cmd, " ", numSymptomsData{n});   		  % NumSymptoms
		cmd = cstrcat(cmd, " ", severityScoreData{n}); 		  % SeverityScore
		cmd = cstrcat(cmd, " ", orientationData{n});   		  % Orientation
		cmd = cstrcat(cmd, " ", orientationTotalData{n});		  % OrientationTotal
		cmd = cstrcat(cmd, " ", immMemData{n});        		  % ImmMem
		cmd = cstrcat(cmd, " ", concentrationData{n}); 		  % Concentration
		cmd = cstrcat(cmd, " ", concentrationTotalData{n}); 	  % ConcentrationTotal
		cmd = cstrcat(cmd, " ", delayedRecallData{n}); 		  % DelayedRecall
		cmd = cstrcat(cmd, " ", SACData{n});           		  % SAC
		cmd = cstrcat(cmd, " ", BESSData{n});          		  % BESS
		cmd = cstrcat(cmd, " ", tandemGaitData{n});  			  % TandemGait
		cmd = cstrcat(cmd, " ", coordinationData{n});  		  % Coordination
    cmd = cstrcat(cmd, " ", plotType);  		            % plotType
		% Suppress output (comment out to display error messages)
    cmd = cstrcat(cmd, " ", ">/dev/null");
    
		%% Run report generation command
		fprintf('\t\tCreating PDF file... ');
		% Change to the current directory
		system(cstrcat("cd", " ", "\"", pwd, "\""));
		status = system(cmd);
		%status = 0;
		
		if (status == 1)
			fprintf('Error: PDF file could not be generated.\n');
			fprintf('\tReport generation for subject %s failed.\n',IDData{n});
			fprintf('\n');
		else
			status = system(cmd); % Run it again to clean up some of the graphics
			fprintf('Done.\n');
			
			%% Encrypt PDF
			% Requires PDFtk Server command-line tool
			% See https://www.pdflabs.com/docs/pdftk-cli-examples/ for examples or 
			% https://www.pdflabs.com/docs/pdftk-man-page/ for a full manual
			%fprintf('\tEncrypting PDF file... ');
			%system("pdftk [filename].pdf output [filename].128.pdf owner_pw [password] user_pw [password]")
			%fprintf('Done.\n');
			
			cmdEncrypt = cstrcat("pdftk \"", subjectReportPath, "/", IDData(n){}, ".pdf\" output \"", subjectReportPath, "/", IDData(n){}, ".128.pdf\" user_pw ", phoneData(n){});
			
			fprintf('\t\tEncrypting PDF file... ');
			statusEncrypt = system(cmdEncrypt);
			fprintf('Done.\n');
			
			% Delete unencrypted file, rename encrypted file
			
			originalFileName = strcat(subjectReportPath, '/', IDData{n}, '.pdf');
			encryptedFileName = strcat(subjectReportPath, '/', IDData{n}, '.128.pdf');

			if exist(originalFileName, 'file')
				delete(originalFileName);
			end
			
			if exist(encryptedFileName, 'file')
				movefile(encryptedFileName, originalFileName);
			end
			
			% Delete scalp plot image
			if exist('scalpplot.png', 'file')
				delete('scalpplot.png');
			end
      
      % Delete scatter plot image
      if exist('scatterplot.png', 'file')
				delete('scatterplot.png');
			end
			
			fprintf('\tReport generation for subject %s completed.\n',IDData{n});
			fprintf('\n');
		end
	else
		fprintf('\t\tError: .mat files not found. Please run initalizeData.m before generating reports.\n');
		fprintf('\tReport generation for subject %s cancelled.\n',IDData{n});
		fprintf('\n');
	end
end

end
