%
% Presents the KCM to the user.
function ShowCurrentKCM(tKCMsManager)
	%
	fprintf('\n\n---------Showing the current KCM--------\n\n')
	%
	fprintf('\nList of prerequisite KCs:\n');
	disp( tKCMsManager.tKCM.astrPrerequisiteKCs );
	%
	fprintf('\nList of merged KCs:\n');
	disp( tKCMsManager.tKCM.astrMergedKCs );
	%
	fprintf('\nList of developed KCs:\n');
	disp( tKCMsManager.tKCM.astrDevelopedKCs );
	%
	fprintf('\nList of teaching and learning Activities:\n');
	disp( tKCMsManager.tKCM.astrTeachLearnActivities );
	%
	fprintf('\nList of intended learning Outcomes:\n');
	disp( tKCMsManager.tKCM.astrIntendedLearnOutcomes );
	%
	input('Press [Return] to proceed', 's');
	fprintf('\nTaxonomy levels in the developed vs. all KCs KCM:\n');
	disp( tKCMsManager.tKCM.aafTaxonomyValues );
	%
	fprintf('\nTaxonomy levels in the KC vs. TLA KCM:\n');
	disp( tKCMsManager.tKCM.aafTaxonomyValuesTLA );
	%
	fprintf('\nTaxonomy levels in the ILO vs. developed KCs KCM:\n');
	disp( tKCMsManager.tKCM.aafTaxonomyValuesILO );
	%
	input('Press [Return] to proceed', 's');
	fprintf('\nInformation on the developed KCs\n');
	disp( tKCMsManager.tKCM.tabDevelopedKCs );
	%
	fprintf('\nInformation on the teaching and learning Activities\n');
	disp( tKCMsManager.tKCM.tabTLAs );
	%
	fprintf('\nInformation on problematic dependencies across developed KCs\n');
	disp( tKCMsManager.tKCM.tabIllegalEdges );
	fprintf('\n\n');
	%
end % function

