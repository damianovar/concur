%
% Selects a program text file from which we generate a table of course
% versions. Does *not* load the KCM:s.
function strPath = SelectProgram(tProgram, strCommand)
	if (nargin > 1)
		%
		% Initialize.
		if (strcmp(strCommand, 'init'))
			strPath = ParametersManager.PARAMS.strPathToProgramsDatabase;
			strFilename = ParametersManager.PARAMS.strDefaultProgram;
		else
			error('Unknown command %s.', strCommand);
		end
	else
		% Hop to the programs database, ask for the program text file, then hop
		% back.
		[strFilename, strPath] = uigetfile({'*.txt' 'Text File'},...
			'Program Text File Select', ParametersManager.PARAMS.strPathToProgramsDatabase);
	end
	if (strPath ~= 0)
		%
		% We chose a file, so we load the table of all versions
		strPath = strcat(strPath, strFilename);
		tProgram.strPath = strPath;
		tProgram.tabAllVersions = readtable(strPath, 'HeaderLines', 0);
	end
end
