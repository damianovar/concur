%
% Detects links from one KC to another where the link requires a
% higher taxonomy level than the KC has been taught at.
% Also detects KCs that are expected to be known at a higher taxonomy level
% than they are taught at.
function DetectBadTaxonomies(tGraph, tKCM)
%
% Get the adjacency matrix and the row names
if (~tKCM.bHasTLAs)
	if (ParametersManager.PARAMS.bVerbose)
		fprintf('The TLA matrix is empty. Taxonomy-related problems will not be detected.\n')
	end
	return;
end
[~, aiWhereInRows] = ismember({tGraph.atTLA2KCLinks(1, :).KC}, tGraph.astrNodesNames);
astrRowNames = tGraph.astrNodesNames(aiWhereInRows);
aafSubAdjacency = tGraph.aafAdjacencyMatrix(aiWhereInRows, :, :);
%
% Find the problematic edges and extract the information
aiHighTLATaxonomy = cellfun(@max, {tGraph.atTLA2KCLinks.taxonomy})';
%
% Handle multiple dimensions
if (tKCM.iTaxonomyCount > 1)
	aiHighTLATaxonomy = reshape(aiHighTLATaxonomy, size(tGraph.atTLA2KCLinks));
	aiHighTLATaxonomy = permute(aiHighTLATaxonomy, [2 3 1]);
end
%
% Seek out the positions of the inadequate taxonomies
[aiBadRows, aiBadColumns] = find(aiHighTLATaxonomy < aafSubAdjacency);
[aiBadColumns, aiBadPages] = ind2sub([size(aafSubAdjacency, 2)...
	size(aafSubAdjacency, 3)], aiBadColumns);
aiBadElements = sub2ind(size(aafSubAdjacency), aiBadRows, aiBadColumns, aiBadPages);
%
% Get their names
astrBadSources = astrRowNames(aiBadRows);
astrBadTargets = tGraph.astrNodesNames(aiBadColumns);
astrBadTypes = tKCM.astrTaxonomies(aiBadPages);
astrBadWeights = aafSubAdjacency(aiBadElements);
acatBadReason = repmat(KCM.CAT_REASON_LOW_TAXONOMY, size(astrBadSources));
%
% Find the problematic nodes as well
astrDevNames = regexp(tKCM.tabDevelopedKCs.CourseAndKC, '(?<=(\w|-)+:).+', 'match');
astrDevNames = [astrDevNames{:}]';
aiTargets = tKCM.tabDevelopedKCs.targetTaxonomy;
aiHighTaxonomy = zeros(size(tGraph.atTLA2KCLinks));
for iKC = 1:size(aiHighTaxonomy, 2)
	aiHighTaxonomy(:, iKC) = max([zeros(1, tKCM.iTaxonomyCount)
		aiTargets(strcmp(astrRowNames{iKC}, astrDevNames), :)]);
end
%
% Find insufficient teachings
abBadTeachings = squeeze(aiHighTLATaxonomy) < aiHighTaxonomy';
acatNodeReason = repmat(KCM.CAT_REASON_TLA_TOO_LOW, nnz(abBadTeachings), 1);
aastrRowNames = repmat(astrRowNames, 1, size(abBadTeachings, 2));
astrBadNodes = aastrRowNames(abBadTeachings);
aiBadHigh = aiHighTaxonomy(abBadTeachings')';
aiBadHigh = reshape(aiBadHigh, numel(aiBadHigh), 1);
[~, aiBadTaxes] = find(abBadTeachings);
astrBadTaxes = tKCM.astrTaxonomies(aiBadTaxes);
%
% Put it in a table
tabBadTaxonomies = table(astrBadSources, astrBadTargets, astrBadTypes, astrBadWeights,...
	acatBadReason, 'VariableNames', KCM.ASTR_HEADERS_ILLEGAL);
tabBadNodeTLA = table(astrBadNodes, astrBadNodes, astrBadTaxes, aiBadHigh, acatNodeReason,...
	'VariableNames', KCM.ASTR_HEADERS_ILLEGAL);
tKCM.tabIllegalEdges = union(tKCM.tabIllegalEdges, [tabBadTaxonomies; tabBadNodeTLA], 'stable');
tGraph.tabIllegalEdges = tKCM.tabIllegalEdges;
end
