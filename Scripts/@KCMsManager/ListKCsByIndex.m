%
% Lists the KCs of the specified type by the type of index specified.
% Parameters:
%	iKCType - the type of KC to list. Must be one of the type
%	constants defined in KCGraph.
%	iIndexType - the type of index to sort by. Must be one of the sorting
%	index constants defined in KCGraph.
%
% FIXME rework the connectivity map
function ListKCsByIndex(tKCMsManager, iKCType, iIndexType)
%
% Get the indices by KC type
switch (iKCType)
	case KCGraph.TYPE_PREREQUISITE
		aiIndices = (1:tKCMsManager.tGraph.iNumberOfPrerequisiteNodes);
		strKCLabel = 'prerequisite KCs';
	case KCGraph.TYPE_DEVELOPED
		aiIndices = (1:tKCMsManager.tGraph.iNumberOfDevelopedNodes)...
			+ tKCMsManager.tGraph.iNumberOfPrerequisiteNodes;
		strKCLabel = 'developed KCs';
	case KCGraph.TYPE_ILO
		aiIndices = (1:tKCMsManager.tGraph.iNumberOfILONodes)...
		+ tKCMsManager.tGraph.iNumberOfPrerequisiteNodes...
		+ tKCMsManager.tGraph.iNumberOfDevelopedNodes;
		strKCLabel = 'intended learning outcomes';
	case KCGraph.TYPE_MERGED
		aiIndices = tKCMsManager.tGraph.iNumberOfNodes...
			- tKCMsManager.tGraph.iNumberOfMergedNodes...
			+ (1:tKCMsManager.tGraph.iNumberOfMergedNodes);
		strKCLabel = 'intermediate KCs';
	otherwise
		error('Unexpected KC type %d', iKCType);
end
%
% Extract the chosen KCs
astrUnsortedKCs = tKCMsManager.tGraph.astrNodesNames(aiIndices);
%
% If the list is empty, abort
if (isempty(astrUnsortedKCs))
	fprintf('No %s exist in this KCM. We cannot proceed.\n', strKCLabel);
	return;
end
%
% Choose centrality or connectivity
switch (iIndexType)
	case KCGraph.SORT_BY_CENTRALITY
		afIndexEvals = tKCMsManager.tGraph.aafCentralityIndexesEvaluations(aiIndices,...
			tKCMsManager.tGraph.iCentralityIndexUserChoice, tKCMsManager.tGraph.iTaxonomyToPlot);
		strIndexLabel = tKCMsManager.tGraph.astrCentralityIndexesTypes{tKCMsManager...
			.tGraph.iCentralityIndexUserChoice};
		strIndexTypeLabel = 'Central';
	case KCGraph.SORT_BY_CONNECTIVITY
		if iKCType == KCGraph.TYPE_ILO
			aiIndices = tKCMsManager.tGraph.iNumberOfPrerequisiteNodes...
				+ (1:tKCMsManager.tGraph.iNumberOfILONodes);
		elseif iKCType ~= KCGraph.TYPE_PREREQUISITE
			fprintf('Connectivity is not computed for KC type %d\n', iKCType);
			return;
		end
		afIndexEvals = tKCMsManager.tGraph.aafConnectivityIndexesEvaluations(aiIndices,...
			tKCMsManager.tGraph.iTaxonomyToPlot);
		strIndexLabel = tKCMsManager.tGraph.astrConnectivityIndexesTypes{tKCMsManager...
			.tGraph.iConnectivityIndexUserChoice};
		strIndexTypeLabel = 'Connected';
	otherwise
		error('Unexpected index type index %d', iIndexType);
end
%
% Get the sorted things (divide by eps + maximum to avoid div/0)
[afSortedIndexEvals, aiSortingIndices] = sort(afIndexEvals, 'descend');
afSortedIndexEvals = afSortedIndexEvals./(eps + max(afIndexEvals));
astrSortedKCs = astrUnsortedKCs(aiSortingIndices);
%
% print the report
fprintf('\n\n---- Report of the Most %s %s By Index "%s" (normalized) ----\n',	...
	strIndexTypeLabel, strKCLabel, strIndexLabel);
fprintf('%4s %7s \t%s\n', 'rank', 'index', strKCLabel)
	%
	for iKC = 1:length(aiIndices)
		%
		fprintf('%4d %7.3f \t%s\n', iKC, afSortedIndexEvals(iKC),...
			astrSortedKCs{iKC});
		%
	end %
end
