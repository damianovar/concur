%
% Similar to PlotKCToCourseRelations, but emphasises the courses
% rather than the KCs.
function hPlot = PlotCourseToKCRelations(atKCMs)
%
% Create the graph and add all the edges: prerequisite edges go from the
% KC to the course, developed edges go from the course to the KC
tGraph = digraph();
astrCourseCodes = {atKCMs.strCourseCode};
for iCourse = 1:numel(atKCMs)
	tThisKCM = atKCMs(iCourse);
	% 
	% Because having empty prerequisites or developed does not work.
	if (~isempty(tThisKCM.astrPrerequisiteKCs))
		tGraph = tGraph.addedge(tThisKCM.astrPrerequisiteKCs, {tThisKCM.strCourseCode}, 1);
	end
	if (~isempty(tThisKCM.astrDevelopedKCs))
		tGraph = tGraph.addedge({tThisKCM.strCourseCode}, tThisKCM.astrDevelopedKCs, 1);
	end
end
%
% Design parameters
fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
fMarkerSize = 10;
%
% Plot it all
figure(ParametersManager.I_FIGURE_INDEX_COURSE2KC);
set(gcf, 'WindowState', 'maximized');
hPlot = plot(tGraph, 'Layout', 'layered', 'Direction', 'right');
set(gca, 'FontSize', get(gca, 'FontSize')*fResolutionMult);
hPlot.highlight(astrCourseCodes, 'MarkerSize', fMarkerSize, 'Marker', 'x',...
	'NodeColor', [0 0.15 0.35]);
hPlot.MarkerSize = hPlot.MarkerSize*fResolutionMult;
hPlot.NodeFontSize = hPlot.NodeFontSize*fResolutionMult;
%xlabel('The ''\times'' is the course.');
%ylabel('Edges going into the course are prerequisites, others are developed.');
title(sprintf('How Course %s +%d Relates to Its KCs', astrCourseCodes{1},...
	numel(atKCMs) - 1));
end
