classdef Launcher < handle
	%
	% ---------------------------------------------------------------------
	properties
		%
		% temporary information to keep track of what has been selected by the user
		iCurrentUserChoice double;
		%
		% this is hard-wired!!
		atValidChoices struct;
		%
		% integers to discriminate (should be constants)
		MAIN_MENU double;
		KCM_ANALYSIS double;
		%
	end % properties
	%
	%
	% ---------------------------------------------------------------------
	methods % non-static
		%
		% standard constructor
		function tLauncher = Launcher()
			%
			% types of menus
			tLauncher.MAIN_MENU		= 1;
			tLauncher.KCM_ANALYSIS	= 2;
			%
			% fix the parameters for each menu
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_PROGRAM			= 1;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).PLOT_PROGRAM				= 2;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).OPEN_APP					= 3;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).SELECT_KCM				= 4;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_CURRENT_KCM			= 5;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).ANALYZE_CURRENT_KCM		= 6;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).CREATE_REPORT				= 7;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).SHOW_DEFAULT_PARAMETERS	= 8;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).CHANGE_PARAMETERS			= 9;
			tLauncher.atValidChoices(tLauncher.MAIN_MENU).EXIT						= 10;
			%
			% fix the parameters for each menu
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SHOW_POTENTIAL_CHOICES			= 1;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_CENTRALITY_INDEX		= 2;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_TAXONOMY				= 10;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_KCG						= 11;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CENTRALITY_INDEXES		= 3;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CONNECTIVITY_INDEXES		= 9;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_PREREQS		= 4;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_DEVED		= 5;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_PREREQS	= 7;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_DEVED		= 8;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SET_NODE_FILTER				= 12;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).DOWNLOAD_EXAM					= 13;
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).EXIT							= 6;
		   	%
			% initialize this with a wrong option
			tLauncher.iCurrentUserChoice = -1;
			%
			if( ParametersManager.PARAMS.bVerbose )
				%
				fprintf('Launcher ready.\n');
				%
			end %
			%
		end % standard constructor
		%
	end % non-static methods
	%
	%
	% ---------------------------------------------------------------------
	methods (Static = true)
		%
		%
	end % static methods
	%
	%
end % classdef
 
