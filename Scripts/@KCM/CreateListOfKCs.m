%
% Creates the lists of prerequisite KCs, developed KCs, teaching
% and learning activities as well as intended learning outcomes.
function CreateListOfKCs( tKCM, tTextual )
	% 
	% Anti-hard-coding helpers
	iPrerequisiteColumn = 1;
	iDevelopedColumn = 2;
	iTeachLearnActColumn = 3;
	iIntendedLearnOutcomesColumn = 4;
	aiInterestingRows = 1 + (1:ParametersManager.PARAMS.iMaxNumberOfKCsInTheKCMFile);
	
	%
	% Extract the various KCs, activities and outcomes
	tKCM.astrPrerequisiteKCs = tTextual.courseSummary(aiInterestingRows,...
										iPrerequisiteColumn);
	tKCM.astrDevelopedKCs = tTextual.courseSummary(aiInterestingRows,...
										iDevelopedColumn);
	tKCM.astrTeachLearnActivities = tTextual.courseSummary(aiInterestingRows,...
										iTeachLearnActColumn);
	tKCM.astrIntendedLearnOutcomes = tTextual.courseSummary(aiInterestingRows,...
										iIntendedLearnOutcomesColumn);
	tKCM.astrMergedKCs = {};
	%
end % function

