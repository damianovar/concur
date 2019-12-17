%
% Detects all instances of developed KCs that depend on KCs that
% are taught in the future.
function DetectNoncausalEdges(tKCM)
%
% Get the first lessons and compare them
aiFirstLessons = tKCM.tabDevelopedKCs.firstLesson;
aabNoncausalConnections = aiFirstLessons < aiFirstLessons';
iDevedCount = length(aiFirstLessons);
%
% Get the interesting part of the taxonomy matrix
aaiDevedToDeved = tKCM.aafTaxonomyValues(end - iDevedCount...
	+ (1:iDevedCount), end - iDevedCount + (1:iDevedCount), :);
aaiIllegalEdges = aaiDevedToDeved.*aabNoncausalConnections;
%
% Look for the illegal edges according to when the developed KCs are
% taught
[aiRows, aiColumns] = find(aaiIllegalEdges);
[aiColumns, aiPages] = ind2sub([size(aaiIllegalEdges, 2) 
	size(aaiIllegalEdges, 3)], aiColumns);
aiPlaces = sub2ind(size(aaiIllegalEdges), aiRows, aiColumns, aiPages);
tKCM.tabIllegalEdges = table(tKCM.astrDevelopedKCs(aiColumns),...
	tKCM.astrDevelopedKCs(aiRows), tKCM.astrTaxonomies(aiPages),...
	aaiIllegalEdges(aiPlaces),...
	repmat(KCM.CAT_REASON_NONCAUSAL, numel(aiRows), 1),...
	'VariableNames', KCM.ASTR_HEADERS_ILLEGAL);
end
