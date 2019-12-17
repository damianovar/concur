function AnalyzeCurrentKCM(tKCMsManager, tProgram)
	%
	% allocate a launcher
	tLauncher = Launcher();
	%
	% Cheap way of getting an invalid handle
	hCITEApp = figure;
	delete(hCITEApp);
	%
	% ask the user what to do, and do stuff while there is something to do
	while(		tLauncher.GetUserChoice(tLauncher.KCM_ANALYSIS,			...
										tKCMsManager			)		...
			~=	tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).EXIT	)
		%
		switch( tLauncher.iCurrentUserChoice )
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SHOW_POTENTIAL_CHOICES
				tKCMsManager.ListAvailableCentralities();
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_CENTRALITY_INDEX
				tKCMsManager.SelectCentralityIndex();
			%
			% There was only one connectivity index...
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_TAXONOMY			
 				tKCMsManager.tGraph.SetActiveTaxonomy();
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_KCG
				if (isvalid(hCITEApp))
					fprintf('There is a CITE app open already. Please close it first.\n');
				elseif (ParametersManager.PARAMS.bUseApp)
					hCITEApp = CITEApp(tProgram);
					fprintf(['\n----- INTERACTIVITY EXPLAINED -----\n> Left-click on'...
						' a node to highlight it. Nodes that are not neighbors to any'...
						' highlighted node will be put in the background,\nas will'...
						' connections that do not go to or from such nodes.\n> '...
						'Right-click on a KC node to show which courses it is'...
						' used in.\n\n']);
				else
					hCITEApp = plot(tKCMsManager.tGraph, 0, tProgram);
				end
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CENTRALITY_INDEXES
				tKCMsManager.tGraph.PlotCentralityIndexes();
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CONNECTIVITY_INDEXES
				tKCMsManager.tGraph.PlotConnectivityIndexes();
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_PREREQS
				tKCMsManager.ListKCsByIndex(KCGraph.TYPE_PREREQUISITE, KCGraph.SORT_BY_CENTRALITY);
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_DEVED
				tKCMsManager.ListKCsByIndex(KCGraph.TYPE_DEVELOPED, KCGraph.SORT_BY_CENTRALITY);
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_PREREQS
				tKCMsManager.ListKCsByIndex(KCGraph.TYPE_PREREQUISITE, KCGraph.SORT_BY_CONNECTIVITY);
			%
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_DEVED
				% Intended learning outcomes could be of greater interest
				% here.
				tKCMsManager.ListKCsByIndex(KCGraph.TYPE_ILO, KCGraph.SORT_BY_CONNECTIVITY);
			% Let's see if people are baited by this...
			% This is merely a way to rickroll people who find this option.
			case tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).DOWNLOAD_EXAM
				KCMsManager.DownloadExam();
			otherwise
				fprintf('This option has been removed\n');
		end % switch
		%
	end % while
	%
	% destroy the app when we are done
	delete(hCITEApp);
end % function

