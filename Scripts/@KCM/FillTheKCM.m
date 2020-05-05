%
% Fills the different matrices in the KCM.
function FillTheKCM( tKCM, tNumeric )
	% Helper variables
	iNoDeveloped = numel(tKCM.astrDevelopedKCs);
	iNoPrerequisite = numel(tKCM.astrPrerequisiteKCs);
	iNoTLA = numel(tKCM.astrTeachLearnActivities);
	iNoILO = numel(tKCM.astrIntendedLearnOutcomes);
	%
	% Version check
	if tNumeric.developedVsPrerequisiteKCs(1) ~= ParametersManager...
			.I_TEMPLATE_VARIANT
		warning(['The KCM of course %s is likely using an old template.'...
			' The representation may be incorrect as a result.'],...
			tKCM.strCourseCode)
	end
	%
	% create the taxonomy value matrices of the KCM
	tKCM.aafTaxonomyValues		= KCM.FillSubKCM(tNumeric...
		.developedVsPrerequisiteKCs, iNoDeveloped, iNoPrerequisite + iNoDeveloped);
	tKCM.aafTaxonomyValuesTLA	= KCM.FillSubKCM(tNumeric...
		.KCsVsTLAs, iNoTLA, iNoPrerequisite + iNoDeveloped);
	tKCM.aafTaxonomyValuesILO	= KCM.FillSubKCM(tNumeric...
		.developedKCsVsILOs, iNoILO, iNoDeveloped);
	%
end % function

