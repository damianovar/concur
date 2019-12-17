% Plots a program. This is a work in progress!
%
function hPlot = Plot(tProgram)
	%
	% Proceed only if the graph would be nontrivial
	if (numel(tProgram.atKCMs) < 2)
		fprintf(['The current program has fewer than two courses.'...
			'As such, plotting it is meaningless.\n']);
		return;
	end
	%
	% Generate layout for the courses
	[aiXPlaces, aiYPlaces, adtXLabels] = tProgram.GetCoordinates();
	%
	% Because the 'InputFormat' parameter has a syntax that is different to
	% that of datestr! Why is that?
	strAdjustedFormat = replace(ParametersManager.PARAMS.strDateFormat, 'M', 'm');
	astrDateLabels = datestr(adtXLabels, strAdjustedFormat);
	tDigraph = tProgram.tAsAGraph;
	%
	% I devised a plotting strategy, as I couldn't find a way to curve the
	% GraphPlot edges without losing placement control. This is that strategy.
	figure(ParametersManager.I_FIGURE_INDEX_PROGRAM);
	set(gcf, 'WindowState', 'maximized');
	%
	% Design parameters
	fTextOffset = -0.1;
	iEdgeLabelPosition = 3;
	fPlotMargin = 0.25;
	fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
	%
	% Get the text first, it should be in the back
	plot(1,1);
	%
	% A different way of holding plots
	set(gca, 'NextPlot', 'add');
	set(gca, 'FontSize', get(gca, 'FontSize')*fResolutionMult);
	text(aiXPlaces, aiYPlaces + fTextOffset, tDigraph.Nodes.Name, ...
		'HorizontalAlignment', 'center', 'FontSize', get(gca, 'FontSize'));
	%
	% Add the edges
	astrCoursesInFocus = {tProgram.atKCMs(tProgram.aiCoursesInFocus).strCourseCode};
	for iEdge = 1:size(tDigraph.Edges.EndNodes, 1)
		%
		% Generate structs for the node coordinates
		tSource.fX = aiXPlaces(strcmp(tDigraph.Edges.EndNodes{iEdge, 1},...
			tDigraph.Nodes.Name));
		tSource.fY = aiYPlaces(strcmp(tDigraph.Edges.EndNodes{iEdge, 1},...
			tDigraph.Nodes.Name));
		tTarget.fX = aiXPlaces(strcmp(tDigraph.Edges.EndNodes{iEdge, 2},...
			tDigraph.Nodes.Name));
		tTarget.fY = aiYPlaces(strcmp(tDigraph.Edges.EndNodes{iEdge, 2},...
			tDigraph.Nodes.Name));
		%
		% Compute their paths because Matlab does not understand that
		% manipulating how the edges are drawn in GraphPlot is not as useless
		% as they think it is... Gee, I could even drop AWGN if this was
		% possible. Oh, I'm rambling again.
		[afPathX, afPathY] = Program.GetArrowPath(tSource, tTarget);
		set(gca, 'ColorOrderIndex', 1);
		%
		% Add the arrow to the plot
		% TODO consider making this call only once
		hLine = plot(afPathX, afPathY, 'LineWidth', sqrt(tDigraph.Edges.Weight(iEdge)...
			*fResolutionMult),...
			'Marker', '>', 'MarkerIndices', length(afPathX), 'MarkerSize',...
			sqrt(tDigraph.Edges.Weight(iEdge)*2)*fResolutionMult, 'ButtonDownFcn', ...
			@tProgram.ProgramPlotCallback);
		%
		% Source and target will be useful
		hLine.UserData.strSource = tDigraph.Edges.EndNodes{iEdge, 1};
		hLine.UserData.strTarget = tDigraph.Edges.EndNodes{iEdge, 2};
		% 
		% Hide the line and its label if it does not connect
		if (~isempty(tProgram.aiCoursesInFocus) && ~(any(strcmp(hLine...
				.UserData.strSource, astrCoursesInFocus))...
			|| any(strcmp(hLine.UserData.strTarget, astrCoursesInFocus))))
			hLine.LineStyle = 'none';
			hLine.MarkerIndices = [];
		else
			text(afPathX(iEdgeLabelPosition) + fTextOffset, afPathY(iEdgeLabelPosition)...
				+ fTextOffset, num2str(tDigraph.Edges.Weight(iEdge)), 'HorizontalAlignment',...
				'center', 'FontSize', get(gca, 'FontSize'));
		end
	end
	%
	% Add the nodes with their labels
	hPlot = scatter(aiXPlaces, aiYPlaces, 'sk', 'LineWidth', 1.5*fResolutionMult,...
		'SizeData', 100	* fResolutionMult^2, 'ButtonDownFcn', @tProgram.ProgramPlotCallback);
	%
	% Give focused nodes a different colour; works even without focused nodes
	hPlot.CData = zeros(size(aiXPlaces));
	hPlot.CData(tProgram.aiCoursesInFocus) = 1;
	xlim([(min(aiXPlaces) - fPlotMargin), (max(aiXPlaces) + fPlotMargin)]);
	ylim([(min(aiYPlaces) - fPlotMargin), (max(aiYPlaces) + fPlotMargin)]);
	%
	% Get the dates on the plot, label axes and add a title
	xticks(unique(aiXPlaces));
	xticklabels(astrDateLabels);
	yticks(1:max(aiYPlaces));
	xlabel('Starting Date');
	ylabel('Course Number');
	title(sprintf('Graphical Representation of Program %s', tProgram.GetName()));
	% 
	% We are done adding lines to the figure
	set(gca, 'NextPlot', 'replace');
	%
	% print some text to help the user understand what she/he can do
	fprintf(['\n--- INTERACTIVITY EXPLAINED ---\n> Left-click once on a course'...
' to highlight it. Only direct connections to or from highlighted nodes'...
' will be displayed.\n> Double-left-click on a course to plot its KC'...
' flow graph.\n> Right-click on a course to display its prerequisite and'...
' developed KCs as a graph.\n> Click on an arrow to display which'...
' KCs go from the source course to the target course.\n\n']);
	%
end % function

