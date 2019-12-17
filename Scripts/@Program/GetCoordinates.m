%
% Generates coordinates for the program plot.
function [aiXPlaces, aiYPlaces, adtXLabels] = GetCoordinates(tProgram)
	%
	adtXPlaces = [tProgram.atKCMs.dtCourseStart];
	%
	% Produce labels as serial date numbers and compress the X coordinates
	% Note to self:
	% afSortedPlaces: where the courses were taken from in the unsorted array,
	% afYPlaces: where they should end up in the sorted array; obtained by
	% sorting the indices and taking the 'from' indices (out param. I)
	[~, aiSortedPlaces] = sort(adtXPlaces);
	[~, aiYPlaces] = sort(aiSortedPlaces);
	adtXLabels = unique(adtXPlaces);
	[~, aiXPlaces] = ismember(adtXPlaces, adtXLabels);
	%
	% in case the labels are invalid datetimes
	if( any(isnat(adtXLabels)) )
		%
		error('At least one course has an invalid datetime. Current datetime format is %s.',...
			ParametersManager.PARAMS.strDateFormat);
		%
	end %
	%
end % function
