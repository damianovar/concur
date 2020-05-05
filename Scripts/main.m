clearvars; close all; clc;
fprintf('----- Welcome to COnCUR! -----\n\n');

% allocate the various objects
% ParametersManager has an instance of parameters manager.
tParametersManager  = ParametersManager.PARAMS;
tLauncher			= Launcher();
tKCMsManager		= KCMsManager();
tProgram			= Program();
tProgram.LoadProgram(tKCMsManager, 'init');
% 
% Get an invalid handle
hApp				= figure(1);
delete(hApp);
%
% ask what to do to the user, and do stuff while there is something to do
while(		tLauncher.GetUserChoice(tLauncher.MAIN_MENU,		...
									tKCMsManager, tProgram	)	...
		~=	tLauncher.atValidChoices(tLauncher.MAIN_MENU).EXIT	)
	switch( tLauncher.iCurrentUserChoice )
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_PROGRAM
			tProgram.LoadProgram(tKCMsManager);
			%
			% Destroy the current app, as it holds the former stuff
			delete(hApp);
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).PLOT_PROGRAM
			tProgram.Plot();
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).OPEN_APP
			%
			% To stop the user from opening hundreds of apps
			if isvalid(hApp)
				fprintf('There is a COnCUR App open already. Please close it first.\n');
			else
				hApp = COnCURApp(tProgram);
			end
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_KCM
			tKCMsManager.SelectKCM(tProgram);
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_CURRENT_KCM
			% `disp' was a Matlab built-in that shouldn't be overloaded.
			% Falling back to `present'.
			present(tKCMsManager); 
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).ANALYZE_CURRENT_KCM
			tKCMsManager.AnalyzeCurrentKCM(tProgram);
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).CREATE_REPORT
			strOutputPath = [tParametersManager.strPathToReportOutput...
				tProgram.GetName()];
			if strcmp(tParametersManager.strReportFormat, 'tex')
				tProgram.GenerateTeXReport(strOutputPath);
			elseif strcmp(tParametersManager.strReportFormat, 'txt')
			try
				%
				delete([strOutputPath '.txt']);
				diary([strOutputPath '.txt']);
				present(tProgram);
				diary off;
			catch tME
				% To ensure the log ends correctly in case anything goes
				% wrong
				diary off;
				rethrow(tME);
			end
			else
				error('Attempted to generate a report of unsupported format %s.',...
					tParametersManager.strReportFormat);
			end
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_DEFAULT_PARAMETERS
			ParametersManager.Print();
		%
		case tLauncher.atValidChoices(tLauncher.MAIN_MENU).CHANGE_PARAMETERS
			ParametersManager.ChangeParameter();
		%
		otherwise
			fprintf('This option has been removed\n');
		%
	end % switch
	%
end % while
disp('Thank you, come again!');
