%
% Retrieves the program name.
function strProgramName = GetName(tProgram)
%
strRegexPatternExtractProgram = '(\w|-)+(?=\.)';
% Extract the program name, which may consist of alphanumerics,
% hyphens and underscores
astrKCMFolder = regexp(tProgram.strPath, strRegexPatternExtractProgram, 'match');
try
	strProgramName = astrKCMFolder{1};
catch tME
	%
	% Have 'none' as placeholder for not having a program loaded
	if (strcmp(tME.identifier, 'MATLAB:badsubscript'))
		strProgramName = 'none';
	else
		rethrow(tME);
	end
end
end
