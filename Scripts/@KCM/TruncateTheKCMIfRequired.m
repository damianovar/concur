function TruncateTheKCMIfRequired(tKCM)
	%
	% Debug? Use the debugger.
	%
	% Find blank KCs that can be removed.
	abNonzeroPrerequisite = strlength(tKCM.astrPrerequisiteKCs) > 0;
	abNonzeroDeveloped = strlength(tKCM.astrDevelopedKCs) > 0;
	abNonzeroMerged = strlength(tKCM.astrMergedKCs) > 0;
	abNonzeroTLA = strlength(tKCM.astrTeachLearnActivities) > 0;
	abNonzeroILO = strlength(tKCM.astrIntendedLearnOutcomes) > 0;
	iThirdDim = numel(tKCM.astrTaxonomies);
	%
	% Find the entries to keep in the various matrices.
	aabEntriesToKeepInTaxonomy = repmat([abNonzeroMerged; abNonzeroDeveloped] ...
		& [abNonzeroPrerequisite' abNonzeroMerged' abNonzeroDeveloped'], 1, 1,...
		iThirdDim);
	aabEntriesToKeepInTLA = repmat(abNonzeroTLA & [abNonzeroPrerequisite' abNonzeroDeveloped'],...
		1, 1, iThirdDim);
	aabEntriesToKeepInILO = repmat(abNonzeroILO & abNonzeroDeveloped', 1, 1, iThirdDim);
	%
	% Remove blank KCs.
	tKCM.astrDevelopedKCs = tKCM.astrDevelopedKCs(abNonzeroDeveloped);
	tKCM.astrPrerequisiteKCs = tKCM.astrPrerequisiteKCs(abNonzeroPrerequisite);
	tKCM.astrMergedKCs = tKCM.astrMergedKCs(abNonzeroMerged);
	tKCM.astrTeachLearnActivities = tKCM.astrTeachLearnActivities(abNonzeroTLA);
	tKCM.astrIntendedLearnOutcomes = tKCM.astrIntendedLearnOutcomes(abNonzeroILO);
	%
	% Remove entries that are of no use.
	tKCM.aafTaxonomyValues = reshape(tKCM.aafTaxonomyValues(aabEntriesToKeepInTaxonomy),...
		sum([abNonzeroDeveloped; abNonzeroMerged]), ...
		sum([abNonzeroDeveloped; abNonzeroMerged; abNonzeroPrerequisite]),...
		iThirdDim);
	tKCM.aafTaxonomyValuesTLA = reshape(tKCM.aafTaxonomyValuesTLA(aabEntriesToKeepInTLA),...
		sum(abNonzeroTLA), sum([abNonzeroDeveloped; abNonzeroPrerequisite]), iThirdDim);
	tKCM.aafTaxonomyValuesILO = reshape(tKCM.aafTaxonomyValuesILO(aabEntriesToKeepInILO),...
		sum(abNonzeroILO), sum(abNonzeroDeveloped), iThirdDim);
	%
end % function

