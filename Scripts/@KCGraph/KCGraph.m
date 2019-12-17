classdef KCGraph < handle
	%
	% ---------------------------------------------------------------------
	properties
		%
		% design parameter?
		iDefaultFigureIndexWhenPlotting double;
		iTaxonomyToPlot double = 1;
		astrTaxonomies cell;
		%
		% quantities that will be computed during the KCM -> graph conversion phase 
		astrNodesNames cell;
		aiNodesTypes double;		% prerequisites or developed
		aafNodesPositions double;	% first prerequisites, then developed, then ILOs, lastly merged
		aafAdjacencyMatrix double;	% TODO remove TLA:s
		%
		% quantities for readability and double-checks that will be updated automatically
		iNumberOfNodes double;
		iNumberOfPrerequisiteNodes double;
		iNumberOfDevelopedNodes double;
		iNumberOfILONodes double;
		iNumberOfMergedNodes double; % There is only one layer of merged nodes at this time
		iNumberOfEdges double;
		%
		% structs that hold the TLA links
		atTLA2KCLinks struct;
		%
		% list of structural problems to show
		acatValidProblems categorical = KCM.GetProblemTypes();
		%
		% matrix collecting the various assessments of the 
		% various centrality indexes of the various nodes
		aafCentralityIndexesEvaluations double;
		aafConnectivityIndexesEvaluations double;
		%
		% quantities useful to plot what the user wants to plot
		iCentralityIndexUserChoice double;
		iConnectivityIndexUserChoice double;
		aiNodesInFocus double;
		bIllegalGraphOnly logical;
		strCourseCode char;
		%
		% labels to define the types of centrality indexes and avoid hard-coding
		% Why aren't these constants?
		astrCentralityIndexesTypes cell;
		astrConnectivityIndexesTypes cell;
		%
		% copied from the KCM
		tabIllegalEdges table;
	end % properties
	%
	%
	% ---------------------------------------------------------------------
	properties (Constant = true)
		%
		% labels to define the types of the nodes and avoid hard-coding
		TYPE_PREREQUISITE double = 1;
		TYPE_DEVELOPED double = 2;
		TYPE_TLA double = 3;
		TYPE_ILO double = 4;
		TYPE_MERGED double = 5;
		SORT_BY_CENTRALITY double = 1;
		SORT_BY_CONNECTIVITY double = 2;
		%
		% labels for the centrality indices
		BETWEENNESS char = 'betweenness';
		INCLOSENESS char = 'incloseness';
		OUTCLOSENESS char = 'outcloseness';
		AUTHORITIES char = 'authorities';
		HUBS char = 'hubs';
		INDEGREE char = 'indegree';
		OUTDEGREE char = 'outdegree';
		PAGERANK char = 'pagerank';
	end
	%
	%
	% ---------------------------------------------------------------------
	methods
		%
		% standard constructor
		function tGraph = KCGraph(~)
			tGraph.iDefaultFigureIndexWhenPlotting = 9999;
			%
			% initialize the strings indicating the centrality indexes
			tGraph.astrCentralityIndexesTypes	= {KCGraph.BETWEENNESS
													KCGraph.PAGERANK
 													KCGraph.INDEGREE
 													KCGraph.OUTDEGREE
 													KCGraph.INCLOSENESS
 													KCGraph.OUTCLOSENESS
 													KCGraph.HUBS
 													KCGraph.AUTHORITIES};
			%
			% initialize the strings indicating the connectivity indexes
			tGraph.astrConnectivityIndexesTypes	= {'maxflow'};% directed
			%
			% set the default choices
			tGraph.iCentralityIndexUserChoice		= 1;
			tGraph.iConnectivityIndexUserChoice		= 1;
			%
			if( ParametersManager.PARAMS.bVerbose )
				%
				tGraph.Print();
				fprintf('KCGraph succesfully constructed\n');
				%
			end %
			%
		end % default constructor
		%
		astrDatatipText = DataCursorCallback(tGraph, hPlot, hEvent);
		hPlotHandle = plot(tGraph, tAxes, tProgram);
		SetLayout(tGraph, hGraphPlot);
		Highlight(tGraph, hGraphPlot);
		strTaxonomy = GetActiveTaxonomy(tGraph);
		SetActiveTaxonomy(tGraph);
		%
	end % methods
	%
	%
end % classdef
 
