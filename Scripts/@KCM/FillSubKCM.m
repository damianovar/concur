%
% Helper function for filling out a sub-KCM. Vectorized version saves lines
% of code!
function aafTaxonomies = FillSubKCM( tNumeric, iNoDeveloped, iNoDependencies )
iOffset = 2;
aafTaxonomies = zeros(iNoDeveloped, iNoDependencies);
%
% Decrease the number of dependencies and dependents if the taxonomy
% matrix is smaller
iNoDeveloped = min(size(tNumeric, 1) - iOffset, iNoDeveloped);
iNoDependencies = min(size(tNumeric, 2) - iOffset, iNoDependencies);
aafTaxonomies(1:iNoDeveloped, 1:iNoDependencies) ...
	= tNumeric(iOffset + (1:iNoDeveloped), iOffset + (1:iNoDependencies));
aafTaxonomies(isnan(aafTaxonomies)) = 0;
if (any(~cellfun(@IsNatural, num2cell(aafTaxonomies)), 'all'))
	error('The taxonomy levels in the KCM must be natural numbers.');
end
end
