%
% Clears the cached spreadsheet.
function ClearCachedSheet()
% There is no common command for Windows, Mac and Unix... why?
if (isunix || ismac)
	system(['rm ' ParametersManager.STR_DEFAULT_TEMP_KCM_NAME]);
elseif (ispc)
	system(['del ' ParametersManager.STR_DEFAULT_TEMP_KCM_NAME]);
else
	error('What system are we running? It is unknown to me.');
end
end
