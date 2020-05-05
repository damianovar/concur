function Print()
	%
	% Not necessary, but easier to read.
	tParams = ParametersManager.PARAMS;
	%
	fprintf('\n\nCurrent parameters (a selection):\n\n')
	fprintf('\tVerbose COnCUR                 %d\n', tParams.bVerbose);
	fprintf('\tPath to KCMs database              %s\n', tParams.strPathToKCMsDatabase);
	fprintf('\tPath to Program database	          %s\n', tParams.strPathToProgramsDatabase);
	fprintf('\tDefault KCM Filename               %s\n', tParams.strDefaultKCMFilename);
	fprintf('\tMaximum Amount of KCs in KCM       %d\n', tParams.iMaxNumberOfKCsInTheKCMFile);
	fprintf('\tPreferred Layering Method in Plot  %s\n', tParams.strPreferredLayeringMethod);
	fprintf('\tPlot KC Flow in App                %d\n', tParams.bUseApp);
	fprintf('\tDate Format                        %s\n', tParams.strDateFormat);
	fprintf('\tGraphics Scaling                   %4.2f\n', tParams.fResolutionMult); 
	%
end % function

