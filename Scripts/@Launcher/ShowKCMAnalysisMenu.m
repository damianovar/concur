%
% Lists the options that are available in the KCM analysis menu.
function ShowKCMAnalysisMenu(tLauncher, tKCMsManager)
	%
	fprintf('\nKCM Analysis Menu: what would you like to do? Actions available:\n')
	%
	fprintf('%d - list the available centrality indices\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SHOW_POTENTIAL_CHOICES);
	%
	fprintf('%d - select the current centrality index  (now: %s)\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_CENTRALITY_INDEX,	...
			tKCMsManager.tGraph.astrCentralityIndexesTypes{tKCMsManager.tGraph.iCentralityIndexUserChoice}	);
	%
	% This option is going to have its purpose changed
	fprintf('%d - change the taxonomy type to analyze\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SELECT_TAXONOMY);
	%
	fprintf('%d - plot the KCG\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_KCG);
	%
	fprintf('%d - plot the centrality indexes\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CENTRALITY_INDEXES);
	%
	fprintf('%d - plot the connectivity indexes\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).PLOT_CONNECTIVITY_INDEXES);
	%
	fprintf('%d - list the most central prerequisite KCs\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_PREREQS);
	%
	fprintf('%d - list the most central developed KCs\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CENTRAL_DEVED);
	%
	fprintf('%d - list the most connected prerequisite KCs\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_PREREQS);
	%
	fprintf('%d - list the most connected learning outcomes\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).LIST_MOST_CONNECTED_DEVED);
	%
	% Is this option necessary? Or should I repurpose it?
	fprintf('%d - coming soon\n', ...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).SET_NODE_FILTER);
	%
	fprintf('%d - download solutions to the upcoming exam \n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).DOWNLOAD_EXAM);
	%
	fprintf('%d - exit the KCM analysis tool\n',	...
			tLauncher.atValidChoices(tLauncher.KCM_ANALYSIS).EXIT);
	%
end % function

