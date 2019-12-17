%
% A place to put code I wanted to keep, but removed when cleaning up.
% Originally from 'Program.Plot'.
error('This script is not to be executed.');
astrAffirmatives = {'yes' 'aye' 'yea' 'yeah' 'ye' 'ofc' 'y'};
astrNegatories = {'no' 'nope' 'nay' 'nah' 'n'};
strOther = 'other';
bInvalidChoice = true;
if (~isempty(varargin) && ischar(varargin{1}) && strcmp(varargin{1}, 'ignore')) 
	bInvalidChoice = false;
end
%
% Perhaps this type of 
while (bInvalidChoice)
	fprintf(['Would you like to plot the KCs associated with the courses',...
	' in focus together with those courses? '])
	strResponse = input('', 's');
	%
	% Yes, plot the KCs.
	if (sum(strcmpi(strResponse, astrAffirmatives)))
		bInvalidChoice = false;
		%
		% Plot the KCs associated with the courses in focus
		if ~isempty(varargin)
			Program.PlotCourseToKCRelations(cellfun(@tProgram.GetKCMByCourseCode,...
				varargin{1}));
		else
			Program.PlotCourseToKCRelations(tProgram.atKCMs);
		end
	%
	% No, it is a whitelist
	elseif (sum(strcmpi(strResponse, astrNegatories)))
		bInvalidChoice = false;
	%
	% Easter egg: This is not a 'yes or no or other' type of question
	elseif (strcmpi(strResponse, strOther))
		fprintf(['Are you a politician? This was a yes or no question, but\n'...
			'I literally got the answer ''other''. Try again.\n']);
	% 
	% Wrong choice
	else
		fprintf(ParametersManager.STR_WRONG_INPUT);
	end
end
%
% The contents of SetNodeFocus.
%
% Sets the nodes to focus on in the graph. Any number of nodes can be
% specified, but they must all be integers within 1 <= n <= [number of
% nodes].
function SetNodeFocus( tKCGraph )
	aiDesiredNodes = 0;
	fprintf(['Choose any number of nodes to focus on. Remove focus from all nodes'...
		' by entering nothing.\n'])
	bInvalidChoice = true;
	% 
	% Keep asking until we are given a matrix of positive integers bounded
	% above by the number of nodes
	while ( bInvalidChoice )
		aiDesiredNodes = unique(input(''));
		bFlag = false;
		if (isempty(aiDesiredNodes))
			break;
		end
		for iNode = aiDesiredNodes
			% Check each entry to see if it is a natural number
			if (~IsNatural(iNode) || iNode < 1 || iNode > tKCGraph.iNumberOfNodes)
				fprintf(ParametersManager.STR_WRONG_INPUT);
				bFlag = true;
				break;
			end
		end
		if (bFlag)
			continue;
		end
		%
		% Statement is reached only if input is valid
		bInvalidChoice = false;
	end
	%
	% Make the focused nodes a column vector for compatibility with the
	% graph plot callback we defined
	tKCGraph.aiNodesInFocus = reshape(aiDesiredNodes, numel(aiDesiredNodes), 1);
	% tKCGraph.Plot();
end
%
% The contents of ImportKCMFromProgram.
%
% Imports a KCM from a program file with Google Sheets links.
% I'm considering to deprecate this function.
function [strFilename, strPath] = ImportKCMFromProgram(tProgram)
	%
	strProgram = tProgram.SelectProgram();
	if (strProgram == 0)
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('No program file was chosen. Returning!');
		end
		strPath = 0;
		strFilename = 0;
		return;
	end
	tabProgram = tProgram.tabAllVersions; % Convenience
	%
	% Helper variables
	iOpenWebsite = 1;
	iUseWget = 2;
	iGetDownloadedKCM = 3;
	%
	% Ask for course code until we get one that is in the program or a
	% blank input
	strCourseCode = KCMsManager.SelectCourseCode(tabProgram);
	if (isempty(strCourseCode))
		strPath = 0;
		strFilename = 0;
		return;
	end
	tabMatches = tabProgram(strcmp(tabProgram.coursecode, strCourseCode), :);
	%
	% Get the version number
	iVersion = KCMsManager.SelectCourseVersion(tabMatches);
	tabSelected = tabMatches(tabMatches.version == iVersion, :);
	%
	% Choose the method of access
	strGoogleSheets = tabSelected.link{1};
	bInvalidStrategyChoice = true;
	fprintf(['How would you like to access this KCM?\nChoose %d to open it in'...
		' a browser,\n%d to load it through wget or\n%d if you'...
		' already downloaded it.\n'], iOpenWebsite, iUseWget, iGetDownloadedKCM);
	while (bInvalidStrategyChoice)
		iStrategyChoice = input('');
		%
		% Did we choose a valid strategy?
		if ismember(iStrategyChoice, [iOpenWebsite iUseWget iGetDownloadedKCM])
			bInvalidStrategyChoice = false;
		else
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	end
	%
	% Patterns for extracting the spreadsheet ID or program
	strRegexPatternExtractID = '(?<=\/d\/)(\w|-)+';
	%
	% Get the directory name
	strKCMFolder = tProgram.GetName();
	% Expected filename is [path to KCM database]/[program name]/
	% [course code]_v[version number].xlsx
	strExpectedPath = [ParametersManager.PARAMS.strPathToKCMsDatabase...
				strKCMFolder '/' strCourseCode '_v' num2str(iVersion) '.xlsx'];
	switch (iStrategyChoice)
		case iOpenWebsite
			%
			% Let the user download the spreadsheet
			web(strGoogleSheets, '-browser');
			input(['Now waiting for the user to download the KCM. Prefer putting '...
				'the downloaded KCM in\n' strExpectedPath '\n']);
			%
			% move the the folder of the databases, so to make the user
			% experience smoother and have the suggested file ready
			% Suggested file name is [course code]_v[version number].
			[strFilename, strPath] = uigetfile({'*.xlsx' 'Excel Spreadsheet'},...
				'KCM Select', strExpectedPath);
		case iUseWget
			%
			% Use wget to download the KCM in the background
			strSheetID = regexp(strGoogleSheets, strRegexPatternExtractID, 'match');
			strSheetID = strSheetID{1};
			[strFilename, strPath] = Program.DownloadKCMWithWget(strSheetID);
			%
			% We can simply add a third parameter to uigetfile to choose a
			% different folder!
		case iGetDownloadedKCM
			%
			[strFilename, strPath] = uigetfile({'*.xlsx', 'Excel Spreadsheet'},...
				'KCM Select', strExpectedPath);
		otherwise
			error('Strategy %d is not supported', iStrategyChoice);
	end
	
end
%
% The contents of SelectCourseVersion.
%
%
% Lets us choose a course version.
function iVersion = SelectCourseVersion(tabMatches)
	% Version Handling
	% Check for dupliate course codes
	iNumberOfHits = size(tabMatches, 1);
	iVersion = max(tabMatches.version);
	if (iNumberOfHits > 1)
		%
		% Multiple versions found---list the options
		fprintf(['There are %d versions of this course. Choose one of the '...
			'following:\n'], iNumberOfHits);
		disp(tabMatches.version);
		fprintf('Leave the input blank to choose the latest version.\n');
		%
		% Ask the user for at most one version
		bInvalidVersionChoice = true;
		while (bInvalidVersionChoice)
			iVersionChoice = input('');
			if (isempty(iVersionChoice)) % Special case: empty input. This is valid.
				bInvalidVersionChoice = false;
			elseif (~isscalar(iVersionChoice) || ~isnumeric(iVersionChoice))
				%
				% We asked for only one numeric element...
				fprintf(ParametersManager.STR_WRONG_INPUT); 
			elseif ismember(iVersionChoice, tabMatches.version)
				%
				% We found a match
				iVersion = iVersionChoice;
				bInvalidVersionChoice = false;
			else
				% No match found
				fprintf(ParametersManager.STR_WRONG_INPUT);
			end
		end
	end
end
%
% The contents of SelectCourseCode.
%
% Selects a subset of the table where the course code matches the code
% supplied by the user.
function strCourse = SelectCourseCode(tabProgram)
%
% List the codes
astrUniqueCodes = unique(tabProgram.coursecode);
fprintf('Which course would you like to look at? Valid course codes are:\n');
disp(astrUniqueCodes);
fprintf('Leave the input blank to go back.');
%
% Ask for a course code until we get one
bInvalidCodeChoice = true;
while (bInvalidCodeChoice)
	strCourse = input('', 's');
	% 
	% Choice is invalid only if we entered any code that is not in the
	% program
	bInvalidCodeChoice = ~(isempty(strCourse) || ismember(strCourse, astrUniqueCodes));
	if (bInvalidCodeChoice)
		fprintf(ParametersManager.STR_WRONG_INPUT);
	end
end
end