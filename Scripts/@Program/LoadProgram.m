% Loads the program file: it holds an array of course flow matrices, the
% path to the program text file and a table of all versions. 
%
function LoadProgram( tProgram, tKCMsManager, strCommand )
%
% Check if command was provided
if (nargin > 2)
	if (strcmp(strCommand, 'init'))
		tProgram.SelectProgram(strCommand);
	else
		error('Unknown command %s.', strCommand);
	end
else
	%
	% First, select the program text file
	strFilename = tProgram.SelectProgram();
	if (strFilename == 0)
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('No program file chosen. Returning!');
		end
		return;
	end
end % else nargin > 2


% Get a table with the entire program, which is generated when the program
% is selected
tabProgram = tProgram.tabAllVersions;
if (ParametersManager.PARAMS.bVerbose)
	fprintf('The following program is going to be loaded:\n');
    disp(tabProgram);
end
astrUniqueCourseCodes = unique(tabProgram.coursecode);
%
% Extract the latest version of each course
aiRowsToKeep = zeros(size(astrUniqueCourseCodes));
for iCourseCode = 1:length(aiRowsToKeep)
	abMatches = strcmp(tabProgram.coursecode, astrUniqueCourseCodes{iCourseCode});
	aiRowsToKeep(iCourseCode) = find(tabProgram.version == max(tabProgram.version(abMatches))...
		& strcmp(tabProgram.coursecode, astrUniqueCourseCodes{iCourseCode}), 1);
end
tabUnique = tabProgram(aiRowsToKeep, :);
%
% Ready the KCM array. Reset the KCM array to discard possible residuals.
tProgram.atKCMs = tProgram.atKCMs(1);
strRegexPatternExtractID = '(?<=\/d\/)(\w|-)+';
if (ParametersManager.PARAMS.bVerbose)
	fprintf('Please wait while we load the courses...\n');
end
for iKCM = length(aiRowsToKeep):-1:1
	strExpectedPath = [ParametersManager.PARAMS.strPathToKCMsDatabase...
				tProgram.GetName() '/' tabUnique{iKCM, 1}{1} '_v'...
				num2str(tabUnique{iKCM, 2}) '.xlsx'];
	%
	try
		%
		% Load the KCM from a local file if it exists
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('Attempting to load from %s\n', strExpectedPath);
		end
		tProgram.atKCMs(iKCM) = KCM();
		tProgram.atKCMs(iKCM).Load(strExpectedPath);
		%
	catch eNoFile
		if (strcmp(eNoFile.identifier, 'MATLAB:importdata:FileNotFound'))
			%
			% The KCM did not exist; download it from Drive
			if (ParametersManager.PARAMS.bVerbose)
				fprintf('The spreadsheet did not exist already; downloading it');
			end
			%
			% Extract the sheet ID
			strSheetID = regexp(tabUnique{iKCM, end}{1}, strRegexPatternExtractID, 'match');
			if( numel(strSheetID) == 0 )
				error('Failed to find a sheet ID for course %s in the program.',...
					tabUnique.coursecode{iKCM});
			end
			strSheetID = strSheetID{1};
			%
			% Download the Excel sheet, then load it
			[strFilename, strPath] = Program.DownloadKCMWithWget(strSheetID);
			tProgram.atKCMs(iKCM).Load([strPath strFilename]);
			%
			% Clear it when we are done and wait a little, as there may be a
			% download limit
			ClearCachedSheet();
			pause(2);
			%
		else
			rethrow(eNoFile);
		end
	end
end
%
% Merge all the KCM:s
if (numel(tProgram.atKCMs) <= 1)
	%
	% Nothing to merge
	tProgram.tProgramKCM = tProgram.atKCMs;
else
	tProgram.tProgramKCM = tProgram.atKCMs(1).Merge(tProgram.atKCMs(2:end));
end
%
% Update the KCM if the KCM manager was passed as a parameter
if (nargin > 1)
	tKCMsManager.tKCM = tProgram.tProgramKCM;
	tKCMsManager.GenerateKCGraph();
end
%
% Create a fake KCM for program prerequisites and program developed
[tFakeKCMPre, tFakeKCMDev] = tProgram.CreateFakeKCMs();
tProgram.atKCMs = [tProgram.atKCMs tFakeKCMPre tFakeKCMDev];
tProgram.GenerateDigraph();
%
end % function

