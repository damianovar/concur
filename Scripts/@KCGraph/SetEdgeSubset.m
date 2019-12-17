%
% Sets a subset of the adjacency matrix.
function SetEdgeSubset(tGraph, aafTaxonomies, iRowOffset, iColumnOffset)
%
% Now vectorized! Use this Matlab feature, dammit!
tGraph.aafAdjacencyMatrix(iRowOffset + (1:size(aafTaxonomies, 1)),...
	iColumnOffset + (1:size(aafTaxonomies, 2)), :) = aafTaxonomies;
end
