%
% Retrieves a set of courses in the specified program that has the
% specified KC/TLA/ILO as well as what type it is in those courses.
% This is done for each KC supplied.
function [atKCMs, aaiTypes] = GetCoursesByKC(tProgram, strKC)
%
% Check each course for the existence of this KC
aabFoundCourses = false(numel(tProgram.atKCMs), numel(strKC));
aaiTypes = zeros(size(aabFoundCourses));
for iKC = 1:size(aabFoundCourses, 2)
	for iCourse = 1:size(aabFoundCourses, 1)
		[aabFoundCourses(iCourse, iKC), aaiTypes(iCourse, iKC)] ...
			= tProgram.atKCMs(iCourse).HasKC(strKC{iKC}); 
	end
end
%
% Leave out mismatches
atKCMs = cell(1, numel(strKC));
aaiTypes = mat2cell(aaiTypes, size(aaiTypes, 1), ones(1, size(aaiTypes, 2)));
for iKC = 1:size(aabFoundCourses, 2)
	atKCMs(iKC) = {tProgram.atKCMs(aabFoundCourses(:, iKC))};
	aiType = aaiTypes{iKC};
	aaiTypes(iKC) = {aiType(aabFoundCourses(:, iKC))};
end
end
