% Detects cycles in a directed graph
%
function DetectCycles(tGraph, tKCM)
	%
	% defensive programming
	if( numel(tGraph.astrNodesNames) ~= numel( unique(tGraph.astrNodesNames) ) )
		%
		error( ['At least one KC, TLA or ILO in one course is represented\n'...
			'as two or more of these in the same course. Check the course summary\n'...
			'tab in %s.'], char(tKCM.strCourseCode))
		%
	end %
	%
	% Generate the digraph and find its cycles
	a3fMatrices = mat2cell(	tGraph.aafAdjacencyMatrix,					...
							size(tGraph.aafAdjacencyMatrix, 1),			...
							size(tGraph.aafAdjacencyMatrix, 2),			...
							ones(size(tGraph.aafAdjacencyMatrix, 3), 1)	);
	tBuiltinDigraph =												...
		squeeze( cellfun(	@digraph,								...
							a3fMatrices,							...
							repmat(	{tGraph.astrNodesNames},		...
									1, 1, numel(a3fMatrices)	),	...
						   	'UniformOutput',						...
							false 									));
	[aiBinNo, aiBinSizes] = cellfun(@conncomp, tBuiltinDigraph, 'UniformOutput', false);
	%
	% Helper function; lets us access all the edge tables simultaneously
	hEdgeExtractor = @(g) g.Edges;
	atabAllEdges = cellfun(hEdgeExtractor, tBuiltinDigraph, 'UniformOutput', false);
	%
	% Allocate a table and cell array for speed
	tabIllegalEdges = table('Size', size(vertcat(atabAllEdges{:})), 'VariableTypes',...
		{'cellstr' 'double'}, 'VariableNames', atabAllEdges{1}.Properties.VariableNames);
	astrBadTaxes = cell(size(tabIllegalEdges, 1), 1);
	tabIllegalEdges.EndNodes = repmat(tabIllegalEdges.EndNodes, 1, 2);
	iRowsFilled = 0;
	%
	aaiBinCyclic = cellfun(@find, cellfun(@gt, aiBinSizes, num2cell(ones(size(aiBinSizes))),...
		'UniformOutput', false), 'UniformOutput', false);
	%
	% Copy the edges to the preallocated table
	for iGraph = 1:tKCM.iTaxonomyCount
		aiBinCyclic = aaiBinCyclic{iGraph};
		for iBin = aiBinCyclic
			tSubgraph = tBuiltinDigraph{iGraph}.subgraph(tGraph...
				.astrNodesNames(aiBinNo{iGraph} == iBin));
			tabThisEdge = tSubgraph.Edges;
			astrBadTaxes(iRowsFilled + (1:size(tabThisEdge, 1))) = tKCM.astrTaxonomies(iGraph);
			tabIllegalEdges(iRowsFilled + (1:size(tabThisEdge, 1)), :) = tabThisEdge;
			iRowsFilled = iRowsFilled + size(tabThisEdge, 1);
		end
	end
	%
	% Discard unused rows
	tabIllegalEdges = tabIllegalEdges(1:iRowsFilled, :);
	astrBadTaxes = astrBadTaxes(1:iRowsFilled);
	acatCyclic = repmat(KCM.CAT_REASON_CYCLIC, size(tabIllegalEdges, 1), 1);
	%
	% This is the table we merge into the real one
	tabToEnter = table(tabIllegalEdges.EndNodes(:, 1), tabIllegalEdges.EndNodes(:, 2),...
		astrBadTaxes, tabIllegalEdges.Weight, acatCyclic, ...
		'VariableNames', KCM.ASTR_HEADERS_ILLEGAL);
	tGraph.tabIllegalEdges = union(tGraph.tabIllegalEdges, tabToEnter, 'stable');
	tKCM.tabIllegalEdges = tGraph.tabIllegalEdges;
	%
end % function

