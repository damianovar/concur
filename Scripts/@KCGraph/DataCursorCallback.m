%
% Called when we place a data cursor on a node in the KCGraph plot.
% It displays the name of the KC/ILO, the value of the current centrality
% index and at which taxonomy level the KC is taught at through the TLA:s.
function astrDatatipText = DataCursorCallback(tGraph, ~, hEvent)
afPointClicked = hEvent.Position;
aafCoords = [hEvent.Target.XData; hEvent.Target.YData; hEvent.Target.ZData]';
[~, iNodeClicked] = ismember(afPointClicked, aafCoords, 'rows');
astrKCs = tGraph.astrNodesNames;
afCentralityIndices = tGraph.aafCentralityIndexesEvaluations(:,...
	tGraph.iCentralityIndexUserChoice, tGraph.iTaxonomyToPlot);
strKCClicked = astrKCs(iNodeClicked);
%
% Look for the TLA label
tTLALabel = tGraph.atTLA2KCLinks(tGraph.iTaxonomyToPlot,...
	strcmp({tGraph.atTLA2KCLinks(tGraph.iTaxonomyToPlot, :).KC},...
	strKCClicked));
astrDatatipText = [strcat({'KC: '}, astrKCs(iNodeClicked))
	strcat(tGraph.astrCentralityIndexesTypes(tGraph.iCentralityIndexUserChoice),...
	{': '}, num2str(afCentralityIndices(iNodeClicked), '%6.2f'))];
if (~isempty(tTLALabel))
	astrDatatipText = [astrDatatipText; {'Taught By TLA:s...'};...
		strcat(tTLALabel.TLA, ": ", num2str(tTLALabel.taxonomy))];
end
if (ParametersManager.PARAMS.bVerbose)
	fprintf('Data Cursor callback');
end
end
