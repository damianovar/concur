%
% Retrieves a KCM by course code in a program.
function tKCM = GetKCMByCourseCode( tProgram, strCourseCode )
if (isempty(tProgram.strPath))
	error(ParametersManager.STR_NO_PROGRAM_ERROR_ID, 'No program has been loaded.');
end
%
% If the optional parameter was supplied
if (nargin == 2)
	if (ischar(strCourseCode))
		tKCM = tProgram.atKCMs(strcmp(strCourseCode, {tProgram.atKCMs.strCourseCode}));
	else
		atKCMsToMerge = tProgram.atKCMs(ismember({tProgram.atKCMs.strCourseCode},...
			strCourseCode));
		%
		% Merge KCM:s only if we found more than one course
		if (numel(atKCMsToMerge) == 1)
			tKCM = atKCMsToMerge;
		elseif (numel(atKCMsToMerge) > 1)
			tKCM = atKCMsToMerge(1).Merge(atKCMsToMerge(2:end));
		end
	end
	return;
end
%
% List the choices
fprintf(['Enter the course code of the course you would like to load.\n'...
	'Leave the input blank to go back without loading a course.\n'...
	'Available course codes are:\n']);
disp({tProgram.atKCMs.strCourseCode}');
%
% Keep asking until we either get a code that exists or a blank
bInvalidChoice = true;
while (bInvalidChoice)
	strCourseCode = input('', 's');
	if (isempty(strCourseCode))
		%
		% Blank entry.
		tKCM = [];
		bInvalidChoice = false;
	elseif (ismember(strCourseCode, {tProgram.atKCMs.strCourseCode}))
		%
		% Course code found! Get the KCM with the matching code.
		tKCM = tProgram.atKCMs(strcmp(strCourseCode, {tProgram.atKCMs.strCourseCode}));
		bInvalidChoice = false;
	else
		fprintf(ParametersManager.STR_WRONG_INPUT);
	end
end
end
