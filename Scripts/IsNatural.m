%
% Checks if the entered variable is a natural number. Useful for brevity.
% Parameter:
%	\entry\ - the item to test.
% Returns:
%	logical \1\ if the entry is a natural number, even if it is a natural
%	number in a floating-point number.
% Remark: 
%	to test all elements in an array or matrix, the elements must be passed
%	one by one or as part of a call to cellfun.
function bNatural = IsNatural(entry)
bNatural = isscalar(entry) && isnumeric(entry) && isreal(entry) && mod(entry, 1) == 0 ...
	&& entry >= 0;
end
