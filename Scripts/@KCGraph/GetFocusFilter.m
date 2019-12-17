% Generates a vector of logicals that can be used to create an adjacency
% matrix for a directed graph that revolves around some node.
function aabFilter = GetFocusFilter( tKCGraph )
	aabFilter = false(tKCGraph.iNumberOfNodes, 1);
	aabFilter(tKCGraph.aiNodesInFocus) = true;
end
