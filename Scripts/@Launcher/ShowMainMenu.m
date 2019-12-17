%
% Presents the main menu action list.
function ShowMainMenu(tLauncher, tKCMsManager, tProgram)
	%
	% Combine the course codes
	strCourseCodeList = string(tKCMsManager.tKCM.strCourseCode);
	strCourseCodeList(1:end-1) = strcat(strCourseCodeList(1:end-1), ", ")';
	strCourseCodeList = [strCourseCodeList{:}];
	%
	fprintf('\nMain Menu: what would you like to do? Actions available:\n')
	%
	fprintf('%d - select a full program to analyze (currently loaded: %s)\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_PROGRAM, ...
		tProgram.GetName());
	%
	fprintf('%d - plot the selected program (%s)\n',...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).PLOT_PROGRAM,...
		tProgram.GetName());
	%
	fprintf('%d - open the CITE app\n',...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).OPEN_APP);
	%
	fprintf('%d - select which KCM you want to analyze\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_KCM);
	%
	fprintf('%d - show the currently selected KCM  (now: %s)\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_CURRENT_KCM,	...
		strCourseCodeList);
	%
	fprintf('%d - analyze the currently selected KCM  (now: %s)\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).ANALYZE_CURRENT_KCM,	...
		strCourseCodeList);
	%
	fprintf('%d - list the editable parameters\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_DEFAULT_PARAMETERS);
	%
	fprintf('%d - change the parameters\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).CHANGE_PARAMETERS);
	%
	fprintf('%d - exit CITE\n',	...
		tLauncher.atValidChoices(tLauncher.MAIN_MENU).EXIT);
	%
end % function

