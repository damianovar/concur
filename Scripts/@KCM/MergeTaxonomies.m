%
% Merges the specified set of taxonomies.
function tMergedData = MergeTaxonomies(tThisData, tOtherData)
%
% For brevity
astrThisPre = tThisData.astrPre;
%astrThisMer = tThisData.astrMer;
astrThisDev = tThisData.astrDev;
astrOtherPre = tOtherData.astrPre;
%astrOtherMer = tOtherData.astrMer;
astrOtherDev = tOtherData.astrDev;
astrThisGoals = tThisData.astrGoals;
astrOtherGoals = tOtherData.astrGoals;
%
% Convert into cell arrays if there are no merged KCs
%if (isempty(astrThisMer)), astrThisMer = {}; end
%if (isempty(astrOtherMer)), astrOtherMer = {}; end
strS = 'stable'; % Preserve order in the sets
%
% Ready the merged KCM
aafTaxonomyThis = tThisData.aafTaxonomies;
aafTaxonomyOther = tOtherData.aafTaxonomies;
aafTaxonomies = zeros(size(aafTaxonomyThis) + size(aafTaxonomyOther));
if (ndims(aafTaxonomies) == 3)
	aafTaxonomies = aafTaxonomies(:, :, 1:size(aafTaxonomyThis, 3));
end
aafTaxonomies(1:size(aafTaxonomyThis, 1), 1:size(aafTaxonomyThis, 2), :)...
	= aafTaxonomyThis;
aafTaxonomies((size(aafTaxonomyThis, 1) + 1):end, (size(aafTaxonomyThis, 2) + 1):end, :)...
	= aafTaxonomyOther;
%
% Combine the KCs
if (tThisData.iWhichSet == KCM.ILO)
	astrKCsThis = astrThisDev;
	astrKCsOther = astrOtherDev;
else
	astrKCsThis = [astrThisPre; astrThisDev];
	astrKCsOther = [astrOtherPre; astrOtherDev];
end
%
% Check if we are working with the KC relationships; if so, use the 
% merged and developed as goals
if (tThisData.iWhichSet == KCM.PMD)
	astrThisGoals = astrThisDev;
	astrOtherGoals = astrOtherDev;
end
%
% Group KCs by category
astrPrereq = [astrThisPre; astrOtherPre];
astrDeved = [astrThisDev; astrOtherDev];
%
% The order in which the KCs appear in the taxonomy matrix at this
% stage
astrKCs = [astrKCsThis; astrKCsOther];
astrGoals = [astrThisGoals; astrOtherGoals];
%
% Detect overlaps among the KCs
[abFoundKCIndices, aiFirstKCIndex] = ismember(astrKCsOther, astrKCsThis);
aiLastKCIndex = (1:numel(abFoundKCIndices))' + numel(astrKCsThis);
[abFoundGoalIndices, aiFirstGoalIndex] = ismember(astrOtherGoals, astrThisGoals);
aiLastGoalIndex = (1:numel(abFoundGoalIndices))' + numel(astrThisGoals);
%
% Columns and rows to remove from the KCM.
aiFirstKCIndex = aiFirstKCIndex(abFoundKCIndices);
aiFirstGoalIndex = aiFirstGoalIndex(abFoundGoalIndices);
%
% The merged columns. Remember these.
aiLastKCIndex = aiLastKCIndex(abFoundKCIndices); 
aiLastGoalIndex = aiLastGoalIndex(abFoundGoalIndices);
%
% Merge the specified columns and remove duplicated KCs.
abColsToKeep = ~ismember(1:size(aafTaxonomies, 2), aiLastKCIndex);
abRowsToKeep = ~ismember(1:size(aafTaxonomies, 1), aiLastGoalIndex);
astrKCs = astrKCs(abColsToKeep);
astrGoals = astrGoals(abRowsToKeep);
if (numel(astrKCs) > ParametersManager.I_KC_CAP)
	error(['The number of KCs in the merged KCM (%d) exceeds the %d '...
		'allowed'], numel(astrKCs), ParametersManager.I_KC_CAP);
end
aafTaxonomies(:, aiFirstKCIndex, :) = max(aafTaxonomies(:, aiFirstKCIndex, :),...
	aafTaxonomies(:, aiLastKCIndex, :));
aafTaxonomies(aiFirstGoalIndex, :, :) = max(aafTaxonomies(aiFirstGoalIndex, :, :),...
	aafTaxonomies(aiLastGoalIndex, :, :));
aafTaxonomies = aafTaxonomies(abRowsToKeep, abColsToKeep, :);
%
% Get the new KCs in place and arrange them
astrNewPre = setdiff(astrPrereq, astrDeved, strS);
astrNewDev = unique(astrDeved, 'stable');
if (tThisData.iWhichSet == KCM.PMD)
	astrNewGoals = astrNewDev;
else
	astrNewGoals = union(astrThisGoals, astrOtherGoals, 'stable'); % Think about it.
end
%
% Determine the column order and row order
if (tThisData.iWhichSet == KCM.ILO)
	[~, aiColumnOrder] = ismember(astrNewDev, astrKCs);
	aiColumnOrder = unique(aiColumnOrder, 'stable');
else
	[~, aiColumnOrder] = ismember([astrNewPre; astrNewDev], astrKCs);
	aiColumnOrder = unique(aiColumnOrder, 'stable');
end
[~, aiRowOrder] = ismember(astrNewGoals, astrGoals); % PROBLEM!
aiRowOrder = unique(aiRowOrder, 'stable');
% aiColumnOrder = aiColumnOrder(aiColumnOrder > 0);
% aiRowOrder = aiRowOrder(aiRowOrder > 0);
aafTaxonomies = aafTaxonomies(aiRowOrder, aiColumnOrder, :);
%
% Get everything into the struct
tMergedData.aafTaxonomies = aafTaxonomies;
tMergedData.astrPre = astrNewPre;
tMergedData.astrDev = astrNewDev;
tMergedData.astrGoals = astrGoals;
end
