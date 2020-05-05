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
	% Check for duplicate KCs
	aastrCheckMatrix = {tKCM.astrPrerequisiteKCs
						tKCM.astrDevelopedKCs
						tKCM.astrTeachLearnActivities
						tKCM.astrIntendedLearnOutcomes};
	aaiIndices = repmat(1:size(aastrCheckMatrix, 1), size(aastrCheckMatrix, 1), 1);
	aabDupes = arrayfun(@(r,c) any(ismember(aastrCheckMatrix{r}...
										(strlength(aastrCheckMatrix{r}) > 0),...
										aastrCheckMatrix{c}...
										(strlength(aastrCheckMatrix{c}) > 0))),...
						aaiIndices', aaiIndices);
	if ~isdiag(double(aabDupes))
		error(ParametersManager.STR_KC_DUPE_ID, ['At least one KC, TLA or ILO is '...
			'of more than one type in the KCM of %s.'], tKCM.strCourseCode);
	end
	%
end % function

