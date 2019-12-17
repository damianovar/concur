%
% Fills the adjacency matrix of the KCGraph by copying the taxonomy values
% from the associated KCM.
function SetEdges( tGraph, tKCM )
	%
	% for readability
	iNumberOfPrerequisites	= numel( tKCM.astrPrerequisiteKCs ); 
	iNumberOfDeveloped	= numel( tKCM.astrDevelopedKCs ); 
	iNumberOfILO = numel( tKCM.astrIntendedLearnOutcomes );
	iNumberOfMerged = numel( tKCM.astrMergedKCs );
	%
	% space allocation
	tGraph.aafAdjacencyMatrix = zeros( tGraph.iNumberOfNodes, tGraph.iNumberOfNodes,...
		numel(tKCM.astrTaxonomies));
	%
	% sanity checks
	abInconsistencies = [tGraph.iNumberOfPrerequisiteNodes ~= iNumberOfPrerequisites
		tGraph.iNumberOfDevelopedNodes ~= iNumberOfDeveloped
		tGraph.iNumberOfILONodes ~= iNumberOfILO
		tGraph.iNumberOfMergedNodes ~= iNumberOfMerged];
	if( any(abInconsistencies) )
		%
		warning(['Inconsistencies found between the KCM and the KCG!\n'...
			'The graph associated to the KCM will not be initialized.']);
		return;
		%
	end%
	%
	% Fill the subsets of the adjacency matrix. Permute to be able to use
	% multiple taxonomies. Leave the TLA:s as they are because their
	% direction is correct: from in rows, to in columns.
	tGraph.SetEdgeSubset(permute(tKCM.aafTaxonomyValues, [2 1 3]),...
		0, iNumberOfPrerequisites);
	tGraph.SetEdgeSubset(permute(tKCM.aafTaxonomyValuesILO, [2 1 3]),...
		iNumberOfPrerequisites, iNumberOfPrerequisites...
		+ iNumberOfDeveloped + iNumberOfMerged);
	%
	% Generate labels for showing which TLA:s teach which KC
	tGraph.SetTLALabels(tKCM);
	%
	% Rearrange the adjacency matrix to fit the order of the KCs
	aiRowOrder = [1:iNumberOfPrerequisites, iNumberOfPrerequisites + iNumberOfMerged...
		+ (1:(iNumberOfDeveloped + iNumberOfILO)), iNumberOfPrerequisites...
		+ (1:(iNumberOfMerged))];
	tGraph.aafAdjacencyMatrix = tGraph.aafAdjacencyMatrix(aiRowOrder, aiRowOrder, :);
	%
	% And compute the number of edges
	tGraph.iNumberOfEdges = squeeze(sum(tGraph.aafAdjacencyMatrix > 0, [1 2]));
end % function
