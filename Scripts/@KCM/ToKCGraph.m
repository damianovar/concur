%
% Creates a KCGraph from this KCM.
function tGraph = ToKCGraph(tKCM)
tGraph = KCGraph();
%
% get the positions of the nodes
tGraph.SetNodesNames( tKCM );
%
% set the communication network
tGraph.SetEdges( tKCM );
%
% compute the centrality indexes
tGraph.ComputeCentralityIndexes();
%
% compute also the connectivity indexes
tGraph.ComputeConnectivityIndexes();
%
% and copy the list of illegal edges
tGraph.tabIllegalEdges = tKCM.tabIllegalEdges;
%
% also, detect bad taxonomies
tGraph.DetectBadTaxonomies(tKCM);
%
% as well as cycles in the graph
tGraph.DetectCycles(tKCM);
%
% and get the taxonomy types in there
tGraph.astrTaxonomies = tKCM.astrTaxonomies;
%
if (ParametersManager.PARAMS.bVerbose)
	tGraph.Print();
	fprintf('KCGraph computed.\n');
end
end
