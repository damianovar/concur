%
% Helper function for creating 3D taxonomy 'tensors'.
function a3fTaxonomies = FillSubKCM3D(tTextual, iNoDeveloped, iNoDependencies,...
	iExpectedPlanes)
iOffset = 2;
%
% Helper variables
strFillIn = repmat('0,', 1, iExpectedPlanes);
strFillIn = strFillIn(1:end - 1);
strBadDimension = ['Expected to find %d dimensions in the taxonomy entry at'...
		' Row %d Column %d; %d dimensions found.'];
%
% Extract the information we need
aastrTextual = tTextual(iOffset + (1:iNoDeveloped), iOffset + (1:iNoDependencies));
aastrTextual = regexp(aastrTextual, '(\d+\s*,?\s*)+', 'match');
aastrTextual(cellfun(@isempty, aastrTextual)) = {{strFillIn}};
%
% To go from cell array of cells to cell array of chars
aastrTextual = reshape([aastrTextual{:}], size(aastrTextual));
%
% This is where we detect errors in the KCM
iFirstCheck = numel(split(aastrTextual(1, 1), ','));
if (iFirstCheck ~= iExpectedPlanes)
	error(strBadDimension, iExpectedPlanes, iOffset + 1, iOffset + 1, iFirstCheck);
end
try
	aastrTextual = split(aastrTextual, ',');
catch tME
	if (strcmp(tME.identifier, 'MATLAB:string:MustHaveSameNumberOf'))
		astrNumbers = regexp(tME.message, '\d+', 'match');
		aiErrorParams = str2double(astrNumbers([1 2]));
		%
		% Error: we found an entry that had the wrong number of taxonomies
		[iRow, iCol] = ind2sub([iNoDeveloped iNoDependencies], aiErrorParams(1));
		error(strBadDimension, iExpectedPlanes, iRow + iOffset, iCol + iOffset,...
			aiErrorParams(2) + 1);
	else
		rethrow(tME);
	end
end
%
% Get the taxonomies in place
a3fTaxonomies = cellfun(@str2double, aastrTextual, 'UniformOutput', false);
a3fTaxonomies = reshape([a3fTaxonomies{:}], size(a3fTaxonomies));
end
