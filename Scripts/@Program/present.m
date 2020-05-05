%
% Prints information about the program.
function present(tProgram)
fprintf('Program Description of %s\n\n', tProgram.GetName());
disp('The program consists of the following courses: ');
disp({tProgram.atKCMs(1:end-2).strCourseCode});

%
% Print information about each KCM, except for the dummy KCM:s.
cellfun(@(tKCM) present(tKCM), num2cell(tProgram.atKCMs(1:end-2)));
end