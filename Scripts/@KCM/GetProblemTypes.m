%
% Used by the COnCUR App to fill in the problem types.
function acatReasons = GetProblemTypes()
	%
	% TODO investigate if there is a way to get all properties of a type
	acatReasons = [KCM.CAT_REASON_NONCAUSAL
		KCM.CAT_REASON_LOW_TAXONOMY
		KCM.CAT_REASON_TLA_TOO_LOW
		KCM.CAT_REASON_CYCLIC];
end