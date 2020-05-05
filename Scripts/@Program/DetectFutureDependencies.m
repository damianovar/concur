function tabFutureDependencies = DetectFutureDependencies(tProgram)
%
% Save key strokes
atKCMs = tProgram.atKCMs(1:end-2);
[~, aiIndexes] = sort([atKCMs.dtCourseStart]);
aastrPrerequisites = {atKCMs(aiIndexes).astrPrerequisiteKCs}';
aastrDeveloped = {atKCMs(aiIndexes).astrDevelopedKCs};
[a3strPrerequisites, a3strDeveloped] = meshgrid(aastrPrerequisites, aastrDeveloped);
a3strConnections = cellfun(@intersect, a3strPrerequisites, a3strDeveloped,...
	'UniformOutput', false);
% If only I could vectorize this...
astrOkay = {};
astrFuture = {};
%
% Go over each course
for iDev = 1:length(atKCMs)
	% 
	astrOkay = union(astrOkay, ...
		setdiff(vertcat(a3strConnections{iDev, (iDev + 1):end}), astrFuture));
	astrFuture = union(astrFuture,...
		setdiff(vertcat(a3strConnections{iDev, 1:(iDev - 1)}), astrOkay));
end
%
% Combine in one table
tabFutureDependencies = table(astrFuture, astrFuture,...
	repmat({ParametersManager.STR_TAXONOMY_NOT_AVAILABLE},...
	size(astrFuture)), ones(size(astrFuture)),...
	repmat(KCM.CAT_REASON_NONCAUSAL, size(astrFuture)),...
	'VariableNames', KCM.ASTR_HEADERS_ILLEGAL);
end