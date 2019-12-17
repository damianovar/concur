%
% Fills the different matrices in the KCM.
function FillTheKCM( tKCM, tNumeric )
	% Helper variables
	iNoDeveloped = numel(tKCM.astrDevelopedKCs);
	iNoPrerequisite = numel(tKCM.astrPrerequisiteKCs);
	iNoTLA = numel(tKCM.astrTeachLearnActivities);
	iNoILO = numel(tKCM.astrIntendedLearnOutcomes);
	%
	% create the taxonomy value matrices of the KCM
	tKCM.aafTaxonomyValues		= KCM.FillSubKCM(tNumeric...
		.developedVsPrerequisiteKCs, iNoDeveloped, iNoPrerequisite + iNoDeveloped);
	tKCM.aafTaxonomyValuesTLA	= KCM.FillSubKCM(tNumeric...
		.KCsVsTLAs, iNoTLA, iNoDeveloped + iNoPrerequisite);
	tKCM.aafTaxonomyValuesILO	= KCM.FillSubKCM(tNumeric...
		.developedKCsVsILOs, iNoILO, iNoDeveloped);
	%
end % function

