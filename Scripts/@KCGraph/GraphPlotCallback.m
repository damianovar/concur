%
% Called when we click on the graph.
function GraphPlotCallback(tGraph, hPlot, hEvent, tAxes, tProgram)
% 
% Compute distances squared in the plot
afClicked = mean(tAxes.CurrentPoint);
afNodeLocations = [hPlot.XData; hPlot.YData; hPlot.ZData]';
%
% Normalize the stuff
aafBounds = [min(hPlot.XData) max(hPlot.XData);
			min(hPlot.YData) max(hPlot.YData);
			0 1]';
%
% Helper anonymous function
hNormalizer = @(dCoord, afBounds)(dCoord - afBounds(1, :))./(afBounds(2, :) - afBounds(1, :));
afDistancesSq = sum((hNormalizer(afClicked, aafBounds)...
	- hNormalizer(afNodeLocations, aafBounds)).^2, 2);
%
% The closest node must be within this distance squared, normalized to the
% bounds of the graph
fToleranceSq = 0.01^2;
if (min(afDistancesSq) > fToleranceSq)
	return;
end
%
% Found the closest node; toggle focus only if we left-click
strChosenLabel = hPlot.NodeLabel(afDistancesSq == min(afDistancesSq));
iChosenNode = find(strcmp(tGraph.astrNodesNames, strChosenLabel), 1);
%
% Verbose
if (ParametersManager.PARAMS.bVerbose)
	fprintf('Graph Plot callback: node hit, ');
end
switch (hEvent.Button)
	case 1 % Left click
		%
		% Use setxor to toggle nodes
		tGraph.aiNodesInFocus = setxor(tGraph.aiNodesInFocus, iChosenNode);
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('toggling focus on node %s\n', [strChosenLabel{:}]);
		end
		%
		% Update the highlighting in the graph plot
		% It should plot again if and only if the taxonomy has changed.
		if (hPlot.UserData.taxonomy == tGraph.iTaxonomyToPlot)
			tGraph.Highlight(hPlot);
		else
			plot(tGraph, tAxes, tProgram);
		end
	case 3 % Right click
		if (tProgram == 0 || numel(tProgram.tabAllVersions) == 0)
			fprintf('Cannot search the program for KCs as no program was provided\n');
			return;
		end
		%
		% Plot the graph of the links of the KC to the courses.
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('showing course connections of node %s\n', [strChosenLabel{:}]);
		end
		tProgram.PlotKCToCourseRelations(strChosenLabel);
	otherwise
		% disp(hEvent.Button);
end
end
