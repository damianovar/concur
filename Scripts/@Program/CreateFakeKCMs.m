%
% Generates a fake KCM that holds the prerequisites and developed for the entire program.
function [tPrereqKCM, tDevedKCM] = CreateFakeKCMs(tProgram)
iDays = 90;
tPrereqKCM = KCM();
tDevedKCM = KCM();
%
% Because we only want the developed KCs that aren't prerequisites
% anywhere.
astrFinalDeved = setdiff(tProgram.tProgramKCM.astrDevelopedKCs,...
	vertcat(tProgram.atKCMs.astrPrerequisiteKCs));
tPrereqKCM.astrDevelopedKCs = tProgram.tProgramKCM.astrPrerequisiteKCs;
tPrereqKCM.dtCourseStart = min([tProgram.atKCMs.dtCourseStart] - iDays);
tPrereqKCM.strCourseCode = '#prerequisite';
tDevedKCM.astrPrerequisiteKCs = astrFinalDeved;
tDevedKCM.dtCourseStart = max([tProgram.atKCMs.dtCourseStart] + iDays);
tDevedKCM.strCourseCode = '#developed';
end
