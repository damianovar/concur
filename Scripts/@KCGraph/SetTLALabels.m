%
% Copies the connections between TLA:s and KCs to an array of structs.
% Fully vectorized.
function SetTLALabels(tKCGraph, tKCM)
%
% Space conservation and legibility
astrKCsInOrder = [tKCM.astrPrerequisiteKCs; tKCM.astrMergedKCs;...
	tKCM.astrDevelopedKCs]';
aafTLATaxonomiesAsCells = mat2cell(tKCM.aafTaxonomyValuesTLA, ...
	numel(tKCM.astrTeachLearnActivities), ones(size(astrKCsInOrder)),...
	ones(numel(tKCM.astrTaxonomies), 1));
%
% Allows indexing via cellfun. This removes the need for loops.
hIndexHelper = @(A, r, c, p) A(r, c, p);
aabWhichElements = cellfun(@gt, aafTLATaxonomiesAsCells, ...
	repmat({0}, size(aafTLATaxonomiesAsCells)), 'UniformOutput', false);
aafFilteredTLA = cellfun(hIndexHelper, aafTLATaxonomiesAsCells, aabWhichElements,...
	repmat({1}, size(aafTLATaxonomiesAsCells)), repmat({1}, ...
	size(aafTLATaxonomiesAsCells)),	'UniformOutput', false);
%
% Fix the problem with KCs that aren't taught at all
abUntaughtKCs = cellfun(@isempty, aafFilteredTLA);
aafFilteredTLA(abUntaughtKCs) = {0};
aastrApplicableTLAs = cellfun(hIndexHelper, repmat({tKCM.astrTeachLearnActivities},...
	1, numel(astrKCsInOrder), tKCM.iTaxonomyCount), aabWhichElements,...
	repmat({1}, size(aafTLATaxonomiesAsCells)), repmat({1},...
	size(aafTLATaxonomiesAsCells)), 'UniformOutput', false);
%
% Get the information into a struct
tKCGraph.atTLA2KCLinks = struct('TLA', aastrApplicableTLAs, 'taxonomy', ...
	aafFilteredTLA, 'KC', repmat(astrKCsInOrder, 1, 1, tKCM.iTaxonomyCount));
%
% Reorder dimensions to get it in 2D (in case of multiple taxonomies: 1-n-p
% to p-n-1)
tKCGraph.atTLA2KCLinks = permute(tKCGraph.atTLA2KCLinks, [3 2 1]);
if (any(abUntaughtKCs, 'all') && ParametersManager.PARAMS.bVerbose)
	fprintf('At least one KC is never taught.\n');
end
end
