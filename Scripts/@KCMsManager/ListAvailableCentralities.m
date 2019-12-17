%
% Lists the available options for choosing centrality index.
function ListAvailableCentralities(tKCMsManager)
	%
	fprintf('\n');
	%
	for iIndex = 1:numel(tKCMsManager.tGraph.astrCentralityIndexesTypes)
		%
		fprintf('centrality index %d = %s\n', iIndex, tKCMsManager.tGraph.astrCentralityIndexesTypes{iIndex});
		%
	end %
	%
end % function

