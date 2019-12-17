% note: every object is passed to the launcher because in this way
% the launcher can write things more precisely in the user menu
% (e.g., filepaths, current choices, etc.) 
%
function iChoice = GetUserChoice(tLauncher, iMenuIndex, tKCMsManager, tProgram)
	%
	bIsChoiceValid = false;
	%
	while( ~bIsChoiceValid )
		%
		% Choose the menu to show
		switch(iMenuIndex)
			%
			case tLauncher.MAIN_MENU
				tLauncher.ShowMainMenu(tKCMsManager, tProgram);
			%
			case tLauncher.KCM_ANALYSIS
				tLauncher.ShowKCMAnalysisMenu(tKCMsManager);
			%
			otherwise
				error('Unrecognized menu index %d', iMenuIndex);
			%
		end % switch
		%
		try
			iChoice = input('your choice: ');
		catch tME
			fprintf('An error occurred when processing your input: \n%s\n',...
				tME.message);
			continue;
		end
		%
		% Valid choices are natural numbers between 1 and EXIT, inclusive
		if( IsNatural(iChoice) ...
				&& 1 <= iChoice && iChoice <= tLauncher.atValidChoices(iMenuIndex).EXIT )
			%
			bIsChoiceValid = true;
			%
		else%
			%
			fprintf(ParametersManager.STR_WRONG_INPUT);
			%
		end %
		%
	end % while
	%
	% save the choice, so to be able to use it somewhere else
	tLauncher.iCurrentUserChoice = iChoice;
	%
end % function

