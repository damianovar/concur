%
% Computes all types of centrality indices of the graph.
function ComputeCentralityIndexes( tGraph )
aafUsableMatrix = tGraph.aafAdjacencyMatrix;
a3fAllMatrices = mat2cell(aafUsableMatrix, size(aafUsableMatrix, 1),...
	size(aafUsableMatrix, 2), ones(size(aafUsableMatrix, 3), 1));
tMatlabGraph = squeeze(cellfun(@digraph, a3fAllMatrices, 'UniformOutput', false));
%
% Removes the need for the first for loop.
astrWhatWeightsMean = repmat({'Importance'}, length(tGraph.astrCentralityIndexesTypes),...
	length(tMatlabGraph));
[astrWhatWeightsMean{ismember(tGraph.astrCentralityIndexesTypes,...
	{KCGraph.BETWEENNESS, KCGraph.INCLOSENESS, KCGraph.OUTCLOSENESS}), :}]...
	= deal('Cost');
%
% Removes the need for the second for loop.
hForRemover = @(g) g.Edges.Weight;
%
% Compute all centrality indices without looping over them
a3fCentralities = cellfun(@centrality, repmat(tMatlabGraph',...
	size(astrWhatWeightsMean, 1), 1), repmat(tGraph.astrCentralityIndexesTypes, size(tMatlabGraph')),...
	astrWhatWeightsMean, repmat(cellfun(hForRemover, tMatlabGraph, 'UniformOutput', false)',...
	size(astrWhatWeightsMean, 1), 1), 'UniformOutput', false);
tGraph.aafCentralityIndexesEvaluations = cell2mat(permute(a3fCentralities, [3 1 2]));
if (ParametersManager.PARAMS.bVerbose)
	fprintf('Done computing centrality indices.\n');
end
end 