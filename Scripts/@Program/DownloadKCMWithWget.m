function [strFilename, strPath] = DownloadKCMWithWget(strSheetID)
%
% Generate target URL and target file
strTargetURL = ['https://docs.google.com/spreadsheet/ccc?key='...
	strSheetID '&output=xlsx&pref=2'];
strFilename = ParametersManager.STR_DEFAULT_TEMP_KCM_NAME;
strPath = './';
%
% Try to download the KCM
if (ismac)
	%
	% Is this correct?
	iSystemStatus = system(['curl -o ' strPath strFilename...
		' ' strTargetURL '']);
elseif (isunix)
	%
	% Is this correct?
	iSystemStatus = system(['wget -o ' strPath strFilename...
		' ' strTargetURL '']);
elseif (ispc)
	iSystemStatus = system(['powershell wget -o ' strPath strFilename...
		' \"' strTargetURL '\"']);
else
	error('I do not recognize this operating system');
end
%
% Zero is A-OK status, so nonzero means something went wrong
if (iSystemStatus)
	warning('Failed to retrieve the KCM; the system status was %d',...
		iSystemStatus);
	strFilename = '';
	strPath = '';
end

end
