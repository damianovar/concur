%
% A module that plots a graph measure, whether it is a centrality measure
% or a connectivity measure.
function PlotGraphMeasure(tGraph, abKCs, aafIndices, astrLabels,...
	afPositions, strIndexType, strKCType)
%
% Design parameter
fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
%
% Axis manipulation
aiKCs = find(abKCs);
set(gca, 'Units', 'normalized'); 
set(gca, 'Position', afPositions);  % [left bottom width height]
aafColors = get(gca, 'ColorOrder');
aafColors = [aafColors; 0.68 0.92 1];
set(gca, 'ColorOrder', aafColors);
set(gca, 'NextPlot', 'add');
set(gca, 'FontSize', get(gca, 'FontSize')*fResolutionMult);
%
% Manipulating because bar doesn't allow a single clustered column
aafBarHeights = aafIndices(	aiKCs, :, tGraph.iTaxonomyToPlot)...
	./ (eps + max(aafIndices(aiKCs, :, tGraph.iTaxonomyToPlot), [], 1));
if (isscalar(aiKCs))
	bar([aafBarHeights; nan(size(aafBarHeights))]);
else
	bar( aiKCs, aafBarHeights);
end
%
% Decorations
title(sprintf('%s indexes of the %s KCs', strIndexType, strKCType));
xticks(aiKCs);
xticklabels(astrLabels);
xtickangle(45);
grid on;
end
