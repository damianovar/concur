function bIsConnected = IsConnected( tGraph, strConnectionStrength )
	%
	% Test the parameters
	if (nargin == 1)
		strConnectionStrength = 'strong';
	elseif ~ismember(strConnectionStrength, {'strong', 'weak'})
		error(['Connection type was expected to be either ''strong'' or '...
			'''weak'', but was found to be ''%s'''], strConnectionStrength);
	end
	tMatlabDigraph = digraph(tGraph.aafAdjacencyMatrix(:, :, tGraph.iTaxonomyToPlot));
	[~, aiBinSizes] = conncomp(tMatlabDigraph, 'Type', strConnectionStrength);
	bIsConnected = numel(aiBinSizes) == 1;
	%
end %
