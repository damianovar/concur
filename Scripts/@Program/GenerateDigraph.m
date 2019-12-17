function GenerateDigraph(tProgram)
%
% Filter out courses
aafAdjacencyMatrix = zeros(numel(tProgram.atKCMs));
astrCourses = {tProgram.atKCMs.strCourseCode};
%
% Create links between courses
for iSource = 1:length(aafAdjacencyMatrix)
	for iTarget = 1:length(aafAdjacencyMatrix)
		aafAdjacencyMatrix(iSource, iTarget) = tProgram.atKCMs(iSource)...
			.GetKCLinkCount(tProgram.atKCMs(iTarget));
	end
end
%
% Get the properties in the plot
tProgram.tAsAGraph = digraph(aafAdjacencyMatrix, astrCourses);
end
