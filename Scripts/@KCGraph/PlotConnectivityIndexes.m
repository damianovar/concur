function PlotConnectivityIndexes( tGraph )
	%
	% Get the connectivities
	[abRelevantNodes, aiWhich] = ismember(tGraph.aiNodesTypes,...
		[KCGraph.TYPE_PREREQUISITE KCGraph.TYPE_ILO]);
	astrRelevantNodes = tGraph.astrNodesNames(abRelevantNodes);
	aiWhich = aiWhich(aiWhich > 0);
	aiPrerequisiteIndices = aiWhich == 1;
	aiILOIndices = aiWhich == 2;
	afConnectivities = permute(tGraph.aafConnectivityIndexesEvaluations, [1 3 2]);
	%
	% Instantiate a figure
	figure(tGraph.iDefaultFigureIndexWhenPlotting);
	set(gcf, 'WindowState', 'maximized');
	refresh(tGraph.iDefaultFigureIndexWhenPlotting);
	%
	% first subfigure = prerequisite KCs
	subplot(2,1,1)
	tGraph.PlotGraphMeasure(aiPrerequisiteIndices, afConnectivities,...
		astrRelevantNodes(aiPrerequisiteIndices), [0.05 0.7 0.9 0.25], 'Connectivity', 'prerequisite');
	hLg = legend( tGraph.astrConnectivityIndexesTypes, 'Location', 'NorthEastOutside',...
		'Box', 'off');% [{on} off]
	hLg.Title.String = tGraph.astrTaxonomies{tGraph.iTaxonomyToPlot};
	%
	%
	% second subfigure = developed KCs
	subplot(2,1,2)
	tGraph.PlotGraphMeasure(aiILOIndices, afConnectivities,...
		astrRelevantNodes(aiILOIndices), [0.05 0.3 0.9 0.25], 'Connectivity',...
		'intended learning outcomes');
	%
	%
end % function
