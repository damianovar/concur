function FillTheKCM3D(tKCM, tTextual)
%
% Helper variables
iNoDeveloped = numel(tKCM.astrDevelopedKCs);
iNoPrerequisite = numel(tKCM.astrPrerequisiteKCs);
iNoTLA = numel(tKCM.astrTeachLearnActivities);
iNoILO = numel(tKCM.astrIntendedLearnOutcomes);
iNoTaxes = numel(tKCM.astrTaxonomies);
%
% Fill each taxonomy 'tensor'
tKCM.aafTaxonomyValues		= KCM.FillSubKCM3D(tTextual...
	.developedVsPrerequisiteKCs, iNoDeveloped, iNoPrerequisite + iNoDeveloped,...
	iNoTaxes);
tKCM.aafTaxonomyValuesTLA	= KCM.FillSubKCM3D(tTextual...
	.KCsVsTLAs, iNoTLA, iNoDeveloped + iNoPrerequisite, iNoTaxes);
tKCM.aafTaxonomyValuesILO	= KCM.FillSubKCM3D(tTextual...
	.developedKCsVsILOs, iNoILO, iNoDeveloped, iNoTaxes);
end
