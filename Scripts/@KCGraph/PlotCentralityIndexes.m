function PlotCentralityIndexes( tGraph )
	%
	% if the graph hasn't been initialized then skip the function
	if( numel(tGraph.aafCentralityIndexesEvaluations) == 0 )
		%
		fprintf('The centrality indexes haven''t been computed yet.\n');
		return;
		%
	end %
	%
	%
	% for readability - logical indexes of where the nodes are
	aiPrerequisiteIndexes	= tGraph.aiNodesTypes == KCGraph.TYPE_PREREQUISITE;
	aiDevelopedIndexes	= tGraph.aiNodesTypes == KCGraph.TYPE_DEVELOPED;
	aiILOIndexes = tGraph.aiNodesTypes == KCGraph.TYPE_ILO;
	%
	%
	% create the figure
	figure(tGraph.iDefaultFigureIndexWhenPlotting);
	set(gcf, 'WindowState', 'maximized');
	refresh(tGraph.iDefaultFigureIndexWhenPlotting);
	%
	% first subfigure = prerequisite KCs
	subplot(3,1,1)
	tGraph.PlotGraphMeasure(aiPrerequisiteIndexes, tGraph.aafCentralityIndexesEvaluations,...
		tGraph.astrNodesNames(aiPrerequisiteIndexes), [0.05 0.75 0.9 0.2], 'Centrality',...
		'Prerequisite');
	hLg = legend( tGraph.astrCentralityIndexesTypes, 'Location', 'NorthEastOutside',...
		'Box', 'off');% [{on} off]
	hLg.Title.String = tGraph.astrTaxonomies{tGraph.iTaxonomyToPlot};
	%
	% second subfigure = developed KCs
	subplot(3,1,2)
	tGraph.PlotGraphMeasure(aiDevelopedIndexes, tGraph.aafCentralityIndexesEvaluations,...
		tGraph.astrNodesNames(aiDevelopedIndexes), [0.05 0.4 0.9 0.2], 'Centrality',...
		'Developed');
	if any(aiILOIndexes)
	%
	% third subfigure = learning outcomes
		subplot(3,1,3);
		tGraph.PlotGraphMeasure(aiILOIndexes, tGraph.aafCentralityIndexesEvaluations,...
			tGraph.astrNodesNames(aiILOIndexes),	[0.05 0.1 0.9 0.15], 'Centrality',...
			'Learning Outcome');
	end
end % function

