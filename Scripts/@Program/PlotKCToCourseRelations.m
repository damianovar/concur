%
% Plots the relations between the provided KCs and the courses.
function hPlot = PlotKCToCourseRelations(tProgram, strChosenLabel)
if (isempty(strChosenLabel))
	fprintf('At least one node must be in focus to be able to plot this.\n');
	return;
end
[atKCMs, aaiTypes] = tProgram.GetCoursesByKC(strChosenLabel);
tGraphOfCourses = digraph();
%
% Add edges for each connection found
for iKC = 1:numel(aaiTypes)
	aiTypes = aaiTypes{iKC};
	astrCourseCodes = {atKCMs{iKC}.strCourseCode};
	tGraphOfCourses = tGraphOfCourses.addedge(strChosenLabel(iKC), ...
		astrCourseCodes(ismember(aiTypes, [KCGraph.TYPE_PREREQUISITE
											KCGraph.TYPE_MERGED])));
	tGraphOfCourses = tGraphOfCourses.addedge(astrCourseCodes(ismember(aiTypes,...
		[KCGraph.TYPE_DEVELOPED; KCGraph.TYPE_MERGED])), strChosenLabel(iKC));
end
%
% Design parameters
fResolutionMult = ParametersManager.PARAMS.fResolutionMult;
fMarkerSize = 10;
% 
% To the plottery
figure(ParametersManager.I_FIGURE_INDEX_KC2COURSE);
set(gcf, 'WindowState', 'maximized');
hPlot = plot(tGraphOfCourses, 'Layout', 'layered', 'Direction', 'right');
%
% Make the KC nodes stand out
set(gca, 'FontSize', get(gca, 'FontSize')*fResolutionMult);
hPlot.highlight(strChosenLabel, 'MarkerSize', fMarkerSize, 'Marker', 'x',...
	'NodeColor', [0 0.15 0.35]);
hPlot.MarkerSize = hPlot.MarkerSize*fResolutionMult;
hPlot.NodeFontSize = hPlot.NodeFontSize*fResolutionMult;
%
% For user-friendliness in the figure
% xlabel('The ''\times'' node represents the KC.');
% ylabel({'An edge going into the KC means it''s developed in the course.'...
% 	'An edge going out of it means it''s a prerequisite for the course.'});
title('How the Chosen KC Relates to the Courses in the Program');
% title(sprintf('How KC %s +%d Relates to the Courses in %s',...
% 	strChosenLabel{1, 1}, numel(strChosenLabel) - 1, tProgram.GetName()));
end
