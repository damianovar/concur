%
% The plot module that governs how nodes and edges are highlighted.
function Highlight(tGraph, hGraphPlot)
%
% Design parameters
aafBadLineColors = [0.95 0.77 0; 0.98 0.43 0; 0.99 0.05 0; 0.93 0 0.4];
fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
fNodeSize = 4;
fEdgeSize = 0.5;
fArrowSize = 7;
fHiddenNodeSize = 1.5;
afHiddenNodeFontColor = [0.75 0.75 0.75];
fFocusedNodeSize = 8;
fNodeFontSize = 8;
fFocusedEdgeSize = 1.5;
%
% Helpers
astrNodeLabels = tGraph.astrNodesNames;
bIsNodeFocused = ~isempty(tGraph.aiNodesInFocus);
%
% Reset the graph plot with little effort
hGraphPlot.ArrowSize = fArrowSize*fResolutionMult;
hGraphPlot.LineStyle = '-';
hGraphPlot.LineWidth = fEdgeSize;
hGraphPlot.MarkerSize = fNodeSize .* fResolutionMult;
hGraphPlot.NodeLabelColor = zeros(1,3);
hGraphPlot.NodeFontAngle = 'normal';
hGraphPlot.NodeFontSize = fNodeFontSize*fResolutionMult;
%
% Get the illegal edges that remain
% Can omit certain types of problems altogether.
tabRemainingIllegal = tGraph.tabIllegalEdges(ismember(...
	tGraph.tabIllegalEdges.reason, tGraph.acatValidProblems) & (~bIsNodeFocused...
	| ismember(tGraph.tabIllegalEdges.source, tGraph.astrNodesNames(tGraph.aiNodesInFocus))...
	| ismember(tGraph.tabIllegalEdges.target, tGraph.astrNodesNames(tGraph.aiNodesInFocus)))...
	& strcmp(tGraph.tabIllegalEdges.type, tGraph.astrTaxonomies(tGraph.iTaxonomyToPlot)), :);
if (tGraph.bIllegalGraphOnly)
	%
	% When we only plot edges that are problematic...
	tIllegalGraph = digraph(tabRemainingIllegal.source, tabRemainingIllegal.target,...
		tabRemainingIllegal.weight, astrNodeLabels, 'omitselfloops');
	hGraphPlot.LineStyle = 'none';
	abIncludedNodes = ismember(astrNodeLabels,...
		union(tabRemainingIllegal.source, tabRemainingIllegal.target));
	%
	% Shrink nodes that neither are in focus nor have any bad edges and
	% gray out their labels
	highlight(hGraphPlot, astrNodeLabels(~abIncludedNodes), 'MarkerSize',...
		fHiddenNodeSize, 'NodeLabelColor', afHiddenNodeFontColor,...
		'NodeFontAngle', 'italic');
	if (bIsNodeFocused)
		highlight(hGraphPlot, astrNodeLabels(tGraph.aiNodesInFocus), 'MarkerSize',...
			fFocusedNodeSize .* fResolutionMult);
	end
	highlight(hGraphPlot, tIllegalGraph, 'LineStyle', '-');
elseif (bIsNodeFocused)
	% 
	% Needed to hide edges we don't want to see.
	set(hGraphPlot, 'LineStyle', 'none');
	abAdjFilter = tGraph.GetFocusFilter();
	aafAdjacencyMatrix = tGraph.aafAdjacencyMatrix.*(abAdjFilter | abAdjFilter');
	aafAdjacencyMatrix = aafAdjacencyMatrix(:, :, tGraph.iTaxonomyToPlot);
	abConnectedNodes = sum(aafAdjacencyMatrix, 1)' | sum(aafAdjacencyMatrix, 2);
	%
	% Shrink nodes without any connection to focused nodes and gray out
	% their labels
	highlight(hGraphPlot, astrNodeLabels(~abConnectedNodes), 'MarkerSize',...
		fHiddenNodeSize, 'NodeLabelColor', afHiddenNodeFontColor,...
		'NodeFontAngle', 'italic');
	%
	% Highlight the part of the graph that has direct connections to
	% any focused node
	tSubplotGraph = digraph(aafAdjacencyMatrix, astrNodeLabels);
	highlight(hGraphPlot, tSubplotGraph, 'LineStyle', '-', 'LineWidth',...
		fFocusedEdgeSize .* fResolutionMult);
	highlight(hGraphPlot, astrNodeLabels(tGraph.aiNodesInFocus), ...
		'MarkerSize', fFocusedNodeSize .* fResolutionMult);
	%
	% Remaining illegal edges must be connected to any KCs in
	% focus
end
%
% Handle illegal edges
if (size(tabRemainingIllegal, 1) > 0)
	% 
	% Sort the edges by problem type; use categorical to our advantage
	abNoncausal = tabRemainingIllegal.reason == KCM.CAT_REASON_NONCAUSAL;
	abLowTaxonomy = tabRemainingIllegal.reason == KCM.CAT_REASON_LOW_TAXONOMY;
	abPoorlyTaught = tabRemainingIllegal.reason == KCM.CAT_REASON_TLA_TOO_LOW;
	abCyclic = tabRemainingIllegal.reason == KCM.CAT_REASON_CYCLIC;
	strSeparator = '->';
	%
	% Highlight the dependent-on-future KC:s or cyclic edges
	aiTaxIndex = tabRemainingIllegal.weight;
	highlight(hGraphPlot, tabRemainingIllegal.source(abNoncausal),...
		tabRemainingIllegal.target(abNoncausal), 'LineStyle', '--');
	highlight(hGraphPlot, tabRemainingIllegal.source(abCyclic), tabRemainingIllegal...
		.target(abCyclic), 'Marker', 'v', 'LineStyle', ':');
	%
	% Highlight the dependent-on-future AND cyclic edges
	astrNoncausalCyclic = intersect(strcat(tabRemainingIllegal.source(abCyclic),...
		strSeparator, tabRemainingIllegal.target(abCyclic)), strcat(tabRemainingIllegal...
		.source(abNoncausal), strSeparator, tabRemainingIllegal.target(abNoncausal)));
	astrNoncausalCyclic = split(astrNoncausalCyclic, strSeparator);
	%
	% To ensure the split cellstr array has two columns
	astrNoncausalCyclic = reshape(astrNoncausalCyclic, numel(astrNoncausalCyclic)/2, 2);
	highlight(hGraphPlot, astrNoncausalCyclic(:, 1), astrNoncausalCyclic(:, 2),...
		'LineStyle', '-.');
	% 
	% Circumvent the constraint to one row in the EdgeColor name-value
	% to highlight inadequate taxonomies
	% TODO prettify
	for iTax = 1:size(aafBadLineColors, 1)
		abWhichLow = abLowTaxonomy & aiTaxIndex == iTax & strcmp(...
			tabRemainingIllegal.type, tGraph.GetActiveTaxonomy());
		abWhichBadTeach = abPoorlyTaught & aiTaxIndex == iTax & strcmp(...
			tabRemainingIllegal.type, tGraph.GetActiveTaxonomy());
		highlight(hGraphPlot, tabRemainingIllegal.source(abWhichLow), ...
			tabRemainingIllegal.target(abWhichLow), ...
			'EdgeColor', aafBadLineColors(iTax, :));
		highlight(hGraphPlot, tabRemainingIllegal.source(abWhichBadTeach),...
			'NodeLabelColor', aafBadLineColors(iTax, :)*0.5);
	end
end
end
