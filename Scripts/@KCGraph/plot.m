%
% Overload the plot function. This is allowed when we deal with different
% classes.
% Plots the Knowledge Component (KC) Graph, attempting to put prerequisite
% components in the layer of sources and learning outcomes in the layer of
% sinks. It highlights the following problems at this stage:
%
% -- A dependency demands a higher taxonomy level than the source KC is
% taught at.
%
% -- A KC should be developed to a higher taxonomy level than it is taught
% at.
%
% -- One KC depends on another KC that is taught later than the first one.
%
% -- A set of KC:s depends on itself (i.e. there is a cycle in the graph).
function hGraphPlot = plot( tGraph, tAxes, tProgram )
	%
	% if the graph hasn't been initialized then skip the function
	if( numel(tGraph.iNumberOfNodes) == 0 )
		%
		fprintf(['The course flow graph hasn''t been initialized yet'...
			' -- skipping its plotting for now\n']);
		return;
		%
	elseif (nargin < 3)
		tProgram = 0;
	end %
	%
	% Check if the axes were provided
	if (~isa(tAxes, 'matlab.graphics.axis.Axes')...
			&& ~isa(tAxes, 'matlab.ui.control.UIAxes'))
		hFig = figure(tGraph.iDefaultFigureIndexWhenPlotting - 1);
		hFig.WindowState = 'maximized';
		iHasAxes = find(isa(hFig.Children, 'matlab.graphics.axis.Axes'), 1);
		%
		% Ensure there is only one pair of axes
		if (isempty(iHasAxes))
			tAxes = axes(hFig);
		else
			tAxes = hFig.Children(iHasAxes);
		end
	end
	%
	% Helper variables
	fFontSize = 10;
	afNodeTaxonomies = ones(tGraph.iNumberOfNodes, 1);
	[~, aiChanges] = ismember({tGraph.atTLA2KCLinks(tGraph...
		.iTaxonomyToPlot, :).KC}, tGraph.astrNodesNames);
	afNodeTaxonomies(aiChanges) = cellfun(@max, {tGraph.atTLA2KCLinks(tGraph...
		.iTaxonomyToPlot, :).taxonomy});
	aafRawAdjacencyMatrix = tGraph.aafAdjacencyMatrix(:, :, tGraph.iTaxonomyToPlot);
	astrNodeLabels = tGraph.astrNodesNames;
	%
	% Get the taxonomies and replace zeroes: '5' is reserved for taxonomy level 0
%	afNodeTaxonomies = afNodeTaxonomies(abFilter);
	afNodeTaxonomies(afNodeTaxonomies == 0) = 5;
	%
	% Remove focus from nodes that are hidden
%	tGraph.aiNodesInFocus = tGraph.aiNodesInFocus(ismember(tGraph...
%		.aiNodesInFocus, find(abFilter)));
	%
	% The new way of plotting the graph; still being researched, but has
	% the benefits of curved arrows!
	tPlotGraph = digraph(aafRawAdjacencyMatrix, astrNodeLabels);
%	tPlotGraph = subgraph(tPlotGraph, astrNodeLabels(abFilter));
	aafLineColors = [0 0.8 0.5; 0 0.6 0.85; 0 0 0.95; 0.4 0 0.88; 0.4 0.4 0.4];
	hGraphPlot = plot(tAxes, tPlotGraph, ...
		'NodeColor', 1 - (1 - aafLineColors(afNodeTaxonomies, :))*0.75, ...
		'ButtonDownFcn', {@tGraph.GraphPlotCallback, tAxes, tProgram},...
		'EdgeColor', aafLineColors(tPlotGraph.Edges.Weight, :));
	hGraphPlot.UserData.taxonomy = tGraph.iTaxonomyToPlot;
	tAxes.FontSize = fFontSize*ParametersManager.PARAMS.fResolutionMult;
	%
	% Modularity: moved all things layout to a separate function; did the
	% same to node highlighting
	tGraph.SetLayout(hGraphPlot);
	tGraph.Highlight(hGraphPlot);
	%
	% Labelling matters
	strCourseCode = string(tGraph.strCourseCode);
	strPlural = ' ';
	if (~isscalar(strCourseCode))
		strPlural = ['s' strPlural];
	end
	strCourseCode(1:end-1) = strcat(strCourseCode(1:end-1), ", ");
	strCourseCode = [strCourseCode{:}];
	title(tAxes, sprintf(['KC Flow Graph Relative to Course%s%s' newline...
		'Taxonomy Type: %s'], strPlural, strCourseCode, tGraph...
		.GetActiveTaxonomy()));
	xlabel(tAxes, 'Qualitative Depiction of Time');
	ylabel(tAxes, 'The closer to purple an edge or a node is, the higher its taxonomy level.');
	%
	% Enable custom data cursor callback (not for uifigure)
	try
		hDataCursorMode = datacursormode(tAxes.Parent);
		hDataCursorMode.UpdateFcn = @(hPlot, hEvent) tGraph.DataCursorCallback(hPlot, hEvent);
	catch tME
		if (strcmp(tME.identifier, 'MATLAB:datacursormode:InvalidFigureHandle'))
			if (ParametersManager.PARAMS.bVerbose)
				fprintf('Cannot add custom data cursor mode to the uifigure.\n');
			end
		else
			rethrow(tME);
		end
	end
end % function
