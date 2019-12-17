%
% Creates the information tables that describe the developed KCs and
% the teaching and learning activities.
function CreateInformationTables( tKCM, tNumeric, tTextual )
%
% Helper variables
iFirstRow = 1;
iLastRow = iFirstRow - 1 + numel(tKCM.astrDevelopedKCs);
iFirstColumn = 2;
iLastColumn = 4;
aiExpectedSize = [iLastRow iLastColumn];
%
% Developed KCs
aaiData = tNumeric.infoOnTheDevelopedKCs;
%
% Just to make stuff work, set to zero if too small
if (any(size(aaiData) < aiExpectedSize)) 
	aaiData = zeros(aiExpectedSize);
end
tKCM.tabDevelopedKCs = array2table(aaiData(iFirstRow:iLastRow, iFirstColumn:iLastColumn),...
	'RowNames', strcat(tKCM.strCourseCode, ':', tKCM.astrDevelopedKCs),...
	'VariableNames', KCM.ASTR_HEADERS_DEV);
tKCM.tabDevelopedKCs.Properties.DimensionNames{1} = 'CourseAndKC';
%
% Handle multiple taxonomies
if (nargin == 3)
	aastrData = tTextual.infoOnTheDevelopedKCs((iFirstRow:iLastRow) + 1,...
		iFirstColumn + 1);
	aastrData = regexp(aastrData, '(\d+\s*,?\s*)+', 'match');
	aastrData = reshape([aastrData{:}], size(aastrData));
	aastrData = split(aastrData, ',');
	tKCM.tabDevelopedKCs.targetTaxonomy = str2double(aastrData);
end
%
% Teach and learn activities
aaiData = tNumeric.infoOnTheTLAs;
iLastRow = iFirstRow - 1 + numel(tKCM.astrTeachLearnActivities);
aiExpectedSize(1) = iLastRow;
%
% Just to make stuff work, set to zero if too small
if (size(aaiData, 1) < aiExpectedSize(1) || size(aaiData, 2) < aiExpectedSize(2)) 
	aaiData = zeros(aiExpectedSize);
end
tKCM.tabTLAs = array2table(aaiData(iFirstRow:iLastRow, iFirstColumn:iLastColumn),...
	'RowNames', strcat(tKCM.strCourseCode, ':', tKCM.astrTeachLearnActivities),...
	'VariableNames', KCM.ASTR_HEADERS_TLA);
tKCM.tabTLAs.Properties.DimensionNames{1} = 'CourseAndActivity';
end
