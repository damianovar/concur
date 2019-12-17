% 
% Retrieves a list of the KCs that are linked from this KCM to the
% provided KCM. Providing the string 'plot' after the next KCM also plots
% the KC links.
function astrKCLinks = GetLinkedKCs(tKCM, tNextKCM, strAction)
%
% Conserve space
astrFromThis = tKCM.astrDevelopedKCs;
astrToNext = tNextKCM.astrPrerequisiteKCs;
astrKCLinks = intersect(astrFromThis, astrToNext, 'stable');
% 
% Plot the connections
if (nargin == 3 && strcmp(strAction, 'plot'))
	%
	% String manipulation to distinguish the nodes
	strThis = 'this:';
	strNext = 'next:';
	astrNodeIDs = [strcat(strThis, astrFromThis); strcat(strNext, astrToNext)];
	%
	% Design parameters
	fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
	aafColors = zeros(numel(astrNodeIDs), 3);
	aafColors(1:numel(astrFromThis), :) ...
		= ones(numel(astrFromThis), 1)*[0.85 0.51 0.12];
	aafColors(numel(astrFromThis) + (1:numel(astrToNext)), :) ...
		= ones(numel(astrToNext), 1)*[0.10 0.88 0.82];
	%
	% Create and plot the graph with a suitable layout
	tGraph = graph(strcat(strThis, astrKCLinks), strcat(strNext, astrKCLinks),...
		1, astrNodeIDs);
	figure(ParametersManager.I_FIGURE_INDEX_CROSSCOURSE);
	set(gcf, 'WindowState', 'maximized');
	hPlot = plot(tGraph, 'Layout', 'layered', 'Direction', 'right',...
		'Sources', astrNodeIDs(startsWith(astrNodeIDs, strThis)),...
		'Sinks', astrNodeIDs(startsWith(astrNodeIDs, strNext)),...
		'NodeLabel', strcat('{', [astrFromThis; astrToNext], '}'), 'NodeColor', aafColors,...
		'EdgeLabel', astrKCLinks);
	set(gca, 'FontSize', get(gca, 'FontSize')*fResolutionMult);
	hPlot.MarkerSize = hPlot.MarkerSize*fResolutionMult;
	hPlot.EdgeFontSize = hPlot.EdgeFontSize*fResolutionMult;
	hPlot.NodeFontSize = hPlot.NodeFontSize*fResolutionMult;
	% 
	% Set the tick labels to help the reader tell to which course the 
	% KCs belong
	xticks([1 2]);
	xticklabels([string(tKCM.strCourseCode(1,:)) 
			string(tNextKCM.strCourseCode(1,:))]);
	%
	% Set labels
	xlabel('Course');
	ylabel('KCs');
	title(sprintf('View of Connection Between Courses %s and %s', tKCM.strCourseCode,...
		tNextKCM.strCourseCode))
end
end
