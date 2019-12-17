%
% Does everything that is related to layout management.
function SetLayout(tGraph, hGraphPlot)
%
% Design parameters
hGraphPlot.ArrowPosition = 0.9;
%
% Handle sources and sinks: they should be TLA:s and ILO:s,
% respectively
astrSources = tGraph.astrNodesNames(1:tGraph.iNumberOfPrerequisiteNodes);
astrSinks = tGraph.astrNodesNames((1:tGraph.iNumberOfILONodes)...
	+ tGraph.iNumberOfPrerequisiteNodes + tGraph.iNumberOfDevelopedNodes);
%
% Can this be done without having four separate layout calls?
% Add sources only if TLA:s exist
strLayerMethod = ParametersManager.PARAMS.strPreferredLayeringMethod;
if (~isempty(astrSources))
	%
	% Add sinks only if ILO:s exist
	if (~isempty(astrSinks))
		hGraphPlot.layout('layered', 'Direction', 'right', 'AssignLayers', ...
			strLayerMethod, 'Sources', astrSources, 'Sinks', astrSinks);
	else
		hGraphPlot.layout('layered', 'Direction', 'right', 'AssignLayers', ...
			strLayerMethod, 'Sources', astrSources);
	end
%
% Add sinks only if ILO:s exist
elseif (~isempty(astrSinks))
	hGraphPlot.layout('layered', 'Direction', 'right', 'AssignLayers', ...
			strLayerMethod, 'Sinks', astrSinks);
else
	hGraphPlot.layout('layered', 'Direction', 'right', 'AssignLayers', ...
			strLayerMethod);
end
end
