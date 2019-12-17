% Algorithm:
%
% - run maxflow depending on which type of weights we have
%
% Parameters: 
%	iSource -- the source node. Should be a nonnegative integer. If set to
%	zero or left out, all prerequisites are hooked up to the source.
%	iSink -- the sink node. Should be a nonnegative integer. If set to
%	zero or left out, all developed are hooked up to the source.
function [fMaximumTotalFlow, tFlowsAtTheMaxRegime] = ComputeConnectivityIndexes( tGraph, iSourceLinks, iSinkLinks )
	%
	% Check for output arguments; if none are given, store the computed
	% indices instead of returning them
	bStoreInGraph = nargout == 0;
	%
	% Default values of source and sink numbers.
	if nargin < 2
		iSourceLinks = 0;
		iSinkLinks = 0;
	elseif nargin < 3
		iSinkLinks = 0;
	end
	%
	% Detect zero values in source and sink
	if iSourceLinks == 0
		iSourceLinks = 1:tGraph.iNumberOfPrerequisiteNodes;
	end
	if iSinkLinks == 0
		iSinkLinks = tGraph.iNumberOfNodes - tGraph.iNumberOfMergedNodes...
			- tGraph.iNumberOfILONodes + (1:tGraph.iNumberOfILONodes);
	end
	%
	% for readability
	aafAdjacencyMatrix = tGraph.aafAdjacencyMatrix;
	%
	% build the Matlab's graph object
	a3fAllMatrices = mat2cell(aafAdjacencyMatrix, size(aafAdjacencyMatrix, 1),...
		size(aafAdjacencyMatrix, 2), ones(size(aafAdjacencyMatrix, 3), 1));
	tMatlabGraph = squeeze(cellfun(@digraph, a3fAllMatrices, 'UniformOutput', false));
	%
	% Add a fake source node and sink node.
	iSource = tGraph.iNumberOfNodes + 2;
	iSink = tGraph.iNumberOfNodes + 1;
	%
	% Compute max flow and store it in the graph only if we do not call the
	% method with any output arguments
	if ( bStoreInGraph )
		%
		% Hook up all developed KCs to a sink and compute max flow for
		% each prerequisite node
		for iGraph = 1:numel(tMatlabGraph)
			tSourceGraph = tMatlabGraph{iGraph}.addedge(iSinkLinks, iSink, Inf);
			for iSourceLinks = 1:tGraph.iNumberOfPrerequisiteNodes
				[tGraph.aafConnectivityIndexesEvaluations(iSourceLinks, iGraph), ~, ~, ~]...
					= maxflow(tSourceGraph.addedge(iSource, iSourceLinks, Inf),...
					iSource, iSink);
			end
			%
			% Vice versa.
			iSourceLinks = 1:tGraph.iNumberOfPrerequisiteNodes;
			tSinkGraph = tMatlabGraph{iGraph}.addedge(iSource, iSourceLinks, Inf);
			for iSinkLinks = (1:tGraph.iNumberOfILONodes) + tGraph...
					.iNumberOfPrerequisiteNodes
				[tGraph.aafConnectivityIndexesEvaluations(iSinkLinks, iGraph), ~, ~, ~]...
					= maxflow(tSinkGraph.addedge(iSinkLinks + tGraph...
					.iNumberOfDevelopedNodes, iSink, Inf),...
					iSource, iSink);
			end
		end
		return;
	end
	%
	% This part has not been adapted for multiple taxonomies
	tMatlabGraph = tMatlabGraph.addedge(iSource, iSourceLinks, Inf);
	tMatlabGraph = tMatlabGraph.addedge(iSinkLinks, iSink, Inf);
	
	%
	% run the maxflow algorithm (note that the source and the sink are the last two nodes)
	[	fMaximumTotalFlow,							...
		tFlowsAtTheMaxRegime,						...
		~,		...
		~	] =	...
			maxflow(tMatlabGraph, iSource, iSink);
	%
	% compute a new adjacency matrix representing the flows at the max-regime - storage allocation
	aafMaxRegimeAdjacencyMatrix = zeros( size(aafAdjacencyMatrix) );
	%
	% cycle on the edges of the digraph returned by maxflow
	for iEdge = 1:numel( tFlowsAtTheMaxRegime.Edges(:,1) )
		%
		% for readability
		iNodeA = tFlowsAtTheMaxRegime.Edges(iEdge,1).EndNodes(1);
		iNodeB = tFlowsAtTheMaxRegime.Edges(iEdge,1).EndNodes(2);
		fFlow  = table2array( tFlowsAtTheMaxRegime.Edges(iEdge,2) );
		%
		% add the info only if it is not relative to the sink or source
		if( iNodeA <= tGraph.iNumberOfNodes && iNodeB <= tGraph.iNumberOfNodes )
			%
			aafMaxRegimeAdjacencyMatrix(iNodeA, iNodeB) = fFlow;
			%
		end %
		%
	end % cycle on the edges of the digraph
	%
	% compute the flow inefficiencies
	% Put a break point here to analyze things.
	% The method for copying a graph was deleted because it was unused.
	aafFlowsInefficiencies = aafAdjacencyMatrix - aafMaxRegimeAdjacencyMatrix;
	
	%
end % function

