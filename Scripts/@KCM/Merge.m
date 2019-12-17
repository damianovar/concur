%
% Recursively merges one KCM with a set of KCM:s.
% It seems to work.
function tMergedKCM = Merge(tKCM, tMergingKCMs)
%
% Support for merging multiple KCM:s
if (isempty(tMergingKCMs))
	tMergedKCM = tKCM;
	if (ParametersManager.PARAMS.bVerbose)
		fprintf('Finished merging KCM:s recursively.\n');
	end
	return;
end
tMergingKCM = tMergingKCMs(1);
%
% First checks: the taxonomies must be identical.
if (tKCM.iTaxonomyCount ~= tMergingKCM.iTaxonomyCount)
	error('The KCM:s to merge differ in number of taxonomies.');
elseif (any(~strcmp(tKCM.astrTaxonomies, tMergingKCM.astrTaxonomies)))
	error('The KCM:s to merge do not have exactly the same taxonomies.');
end
%
% Check for duplicate courses -- we cannot have any of them
astrDuplicateCourses = intersect(string(tKCM.strCourseCode), string(tMergingKCM.strCourseCode));
if ( ~isempty(astrDuplicateCourses) )
	error(ParametersManager.STR_MERGE_ERROR_ID, 'Duplicate courses found in the KCM.');
end
%
% Create the KCM and get the course codes combined
tMergedKCM = KCM();
tMergedKCM.strCourseCode = union(string(tKCM.strCourseCode),...
	string(tMergingKCM.strCourseCode), 'stable');
tMergedKCM.astrTaxonomies = tKCM.astrTaxonomies;
tMergedKCM.iTaxonomyCount = tKCM.iTaxonomyCount;
%
% Generate structs for the helper method
% Here, the KC-to-KC matrices
tThisData.aafTaxonomies = tKCM.aafTaxonomyValues;
tThisData.astrPre = tKCM.astrPrerequisiteKCs;
tThisData.astrDev = tKCM.astrDevelopedKCs;
tThisData.astrGoals = {};
tThisData.iWhichSet = KCM.PMD;
tOtherData.aafTaxonomies = tMergingKCM.aafTaxonomyValues;
tOtherData.astrPre = tMergingKCM.astrPrerequisiteKCs;
tOtherData.astrDev = tMergingKCM.astrDevelopedKCs;
tOtherData.astrGoals = {};
%
% Get everything regarding KC development
tKCDevelopment = KCM.MergeTaxonomies(tThisData, tOtherData);
tMergedKCM.aafTaxonomyValues = tKCDevelopment.aafTaxonomies;
tMergedKCM.astrPrerequisiteKCs = tKCDevelopment.astrPre;
tMergedKCM.astrDevelopedKCs = tKCDevelopment.astrDev;
%
% Move on to teaching and learning activities
tThisData.astrGoals = tKCM.astrTeachLearnActivities;
tThisData.aafTaxonomies = tKCM.aafTaxonomyValuesTLA;
tThisData.iWhichSet = KCM.TLA;
tOtherData.astrGoals = tMergingKCM.astrTeachLearnActivities;
tOtherData.aafTaxonomies = tMergingKCM.aafTaxonomyValuesTLA;

tTeachLearnActivities = KCM.MergeTaxonomies(tThisData, tOtherData);
tMergedKCM.aafTaxonomyValuesTLA = tTeachLearnActivities.aafTaxonomies;
tMergedKCM.astrTeachLearnActivities = tTeachLearnActivities.astrGoals;
%
% And then the intended learning outcomes
tThisData.astrGoals = tKCM.astrIntendedLearnOutcomes;
tThisData.aafTaxonomies = tKCM.aafTaxonomyValuesILO;
tThisData.iWhichSet = KCM.ILO;
tOtherData.astrGoals = tMergingKCM.astrIntendedLearnOutcomes;
tOtherData.aafTaxonomies = tMergingKCM.aafTaxonomyValuesILO;

tIntendedLearnOutcomes = KCM.MergeTaxonomies(tThisData, tOtherData);
tMergedKCM.aafTaxonomyValuesILO = tIntendedLearnOutcomes.aafTaxonomies;
tMergedKCM.astrIntendedLearnOutcomes = tIntendedLearnOutcomes.astrGoals;
%
% Merge the tables as well.
tMergedKCM.tabDevelopedKCs = [tKCM.tabDevelopedKCs; tMergingKCM.tabDevelopedKCs];
tMergedKCM.tabTLAs = [tKCM.tabTLAs; tMergingKCM.tabTLAs];
tMergedKCM.bHasTLAs = tKCM.bHasTLAs | tMergingKCM.bHasTLAs;
if any(xor(tKCM.bHasTLAs, tMergingKCM.bHasTLAs))
	warning(ParametersManager.STR_WARN_DIM_MISMATCH, tKCM.strCourseCode,...
		tMergingKCM.strCourseCode, 'TLA');
end
tMergedKCM.bHasILOs = tKCM.bHasILOs | tMergingKCM.bHasILOs;
if any(xor(tKCM.bHasILOs, tMergingKCM.bHasILOs))
	warning(ParametersManager.STR_WARN_DIM_MISMATCH, tKCM.strCourseCode,...
		tMergingKCM.strCourseCode, 'ILO');
end
%
% Only merge noncausal teachings, since the taught taxonomy level for
% merged KCs could be different
tMergedKCM.tabIllegalEdges...
	= union(tKCM.tabIllegalEdges(tKCM.tabIllegalEdges.reason...
	== KCM.CAT_REASON_NONCAUSAL, :),...
	tMergingKCM.tabIllegalEdges(tMergingKCM.tabIllegalEdges.reason...
	== KCM.CAT_REASON_NONCAUSAL, :), 'stable');
%
% Recursively merge with more KCM:s

tMergedKCM = tMergedKCM.Merge(tMergingKCMs(2:end));
end
