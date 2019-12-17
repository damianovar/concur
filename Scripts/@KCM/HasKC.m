%
% Checks if a KCM has a given KC in any category. Also returns the
% type of KC.
function [bKCFound, iTypeOfKC] = HasKC(tKCM, strKC)
abKCsMatched = strcmp([tKCM.astrPrerequisiteKCs
						tKCM.astrMergedKCs
						tKCM.astrDevelopedKCs
						tKCM.astrTeachLearnActivities
						tKCM.astrIntendedLearnOutcomes], strKC);
%
% Build the type list in the same order as we searched the list
aiTypeList = [ones(size(tKCM.astrPrerequisiteKCs))*KCGraph.TYPE_PREREQUISITE
			ones(size(tKCM.astrMergedKCs))*KCGraph.TYPE_MERGED
			ones(size(tKCM.astrDevelopedKCs))*KCGraph.TYPE_DEVELOPED
			ones(size(tKCM.astrTeachLearnActivities))*KCGraph.TYPE_TLA
			ones(size(tKCM.astrIntendedLearnOutcomes))*KCGraph.TYPE_ILO];
bKCFound = abKCsMatched'*abKCsMatched > 0;
iTypeOfKC = aiTypeList(abKCsMatched);
if (isempty(iTypeOfKC))
	iTypeOfKC = 0;
end
end
