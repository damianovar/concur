%
% Allows the user to change certain parameters in the parameters manager.
function ChangeParameter()
tParams = ParametersManager.PARAMS;
astrValidParams = {'verbose', 'KCM path', 'program path', 'default KCM',...
	'layer method', 'KC cap', 'plot in app', 'date format', 'label scale',...
	'report format'};
fprintf('The available parameters are: \n');
disp(astrValidParams');
strParameter = input('Change which parameter? ', 's');
iWhich = find(strcmpi(astrValidParams, strParameter), 1);
if (isempty(iWhich))
	fprintf(ParametersManager.STR_WRONG_INPUT);
	return;
end
strNewParam = input('To what? (Leave blank to cancel.) ', 's');
if (isempty(strNewParam)) 
	return;
end
%
% Curse our hard-coding if you wish.
switch (iWhich)
	case 1 % Verbose
		if (strcmpi(strNewParam, 'true'))
			tParams.bVerbose = true;
		elseif (strcmpi(strNewParam, 'false'))
			tParams.bVerbose = false;
		else
			bVerbose = str2double(strNewParam);
			if (isnan(bVerbose))
				fprintf(ParametersManager.STR_WRONG_INPUT);
			else
				tParams.bVerbose = logical(bVerbose);
			end
		end
	case 2 % KCM database
		tParams.strPathToKCMsDatabase = strNewParam;
	case 3 % Programs database
		tParams.strPathToProgramsDatabase = strNewParam;
	case 4 % Default KCM name
		tParams.strDefaultKCMFilename = strNewParam;
	case 5 % Layering method
		astrValidParams = {'auto', 'asap', 'alap'};
		if (ismember(strNewParam, astrValidParams))
			tParams.strPreferredLayeringMethod = strNewParam;
		else
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	case 6 % KC cap
		iNoOfKCs = str2double(strNewParam);
		if (isfinite(iNoOfKCs) && iNoOfKCs > 0)
			tParams.iMaxNumberOfKCsInTheKCMFile = iNoOfKCs;
		else
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	case 7 % Plot in app
		if (strcmpi(strNewParam, 'true'))
			tParams.bUseApp = true;
		elseif (strcmpi(strNewParam, 'false'))
			tParams.bUseApp = false;
		else
			bUseApp = str2double(strNewParam);
			if (isnan(bUseApp))
				fprintf(ParametersManager.STR_WRONG_INPUT);
			else
				tParams.bUseApp = logical(bUseApp);
			end
		end
	case 8 % Date format
		try
			datestr(1, strNewParam);
			tParams.strDateFormat = strNewParam;
		catch tME
			disp(tME.identifier);
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	case 9
		fScale = str2double(strNewParam);
		if (fScale < ParametersManager.F_MIN_SCALE) 
			fprintf(['The number you have entered (%4.2f) is too small, '...
				'it must be at least %4.2f\n'], fScale, ParametersManager...
				.F_MIN_SCALE);
		elseif(fScale > ParametersManager.F_MAX_SCALE)
			fprintf(['The number you have entered (%4.2f) is too big, '...
				'it must be at most %4.2f\n'], fScale, ParametersManager...
				.F_MAX_SCALE);
		elseif (isfinite(fScale))
			tParams.fResolutionMult = fScale;
		else
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	case 10
		if ismember(strNewParam, ParametersManager.ACAT_REPORT_FORMAT_LIST)
			tParams.strReportFormat = strNewParam;
		else
			fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	otherwise
		error('Unrecognised parameter %s.', strParameter);
end
end
