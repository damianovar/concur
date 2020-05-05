%
% Lists the most important information in the KCM. By default, it shows the
% KC:s, TLA:s and ILO:s.
function present(tKCM)
iInfoLevel = ParametersManager.PARAMS.bVerbose;
bHasTLAs = ~isempty(tKCM.astrTeachLearnActivities);
bHasILOs = ~isempty(tKCM.astrIntendedLearnOutcomes);

disp('----------------------------------------');
fprintf('Content Report of Course %s\n\n', tKCM.strCourseCode);

disp('Prerequisite KC:s');
disp(tKCM.astrPrerequisiteKCs);

disp('Developed KC:s');
disp(tKCM.astrDevelopedKCs);

if bHasTLAs
	disp('Teaching and Learning Activities');
	disp(tKCM.astrTeachLearnActivities);
end

if bHasILOs
	disp('Intended Learning Outcomes');
	disp(tKCM.astrIntendedLearnOutcomes);
end

if size(tKCM.tabIllegalEdges, 1) > 0
	disp('Structural Issues');
	disp(tKCM.tabIllegalEdges);
end
%
% The information below is only provided if information level 1 or higher
% is specified.
if iInfoLevel < 1
	return
end

disp('Dependencies Across KC:s');
disp(tKCM.ToTable(KCM.PMD));

disp('Details on Developed KC:s');
disp(tKCM.tabDevelopedKCs);

if bHasTLAs
	disp('What TLA:s Teach');
	disp(tKCM.ToTable(KCM.TLA));
	
	disp('Details on TLA:s');
	disp(tKCM.tabTLAs);
end

if bHasILOs
	disp('How Developed KC:s Connect to ILO:s');
	disp(tKCM.ToTable(KCM.ILO));
end
end