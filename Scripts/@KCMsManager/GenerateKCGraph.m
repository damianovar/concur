function GenerateKCGraph(tKCMsManager)
	%
	% reinitialize the graph
	tKCMsManager.tGraph = tKCMsManager.tKCM.ToKCGraph();
end % function

