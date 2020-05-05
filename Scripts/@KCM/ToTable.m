%
% Converts a dependency matrix in the KCM to a table representation.
function tabRelations = ToTable(tKCM, iType)
switch iType
	case KCM.PMD
		astrDependencies = [tKCM.astrPrerequisiteKCs
							tKCM.astrDevelopedKCs];
		astrDependents = tKCM.astrDevelopedKCs;
		aafWorkingSheet = tKCM.aafTaxonomyValues;
	case KCM.TLA
		astrDependencies = tKCM.astrTeachLearnActivities;
		astrDependents = [tKCM.astrPrerequisiteKCs
							tKCM.astrDevelopedKCs];
		aafWorkingSheet = tKCM.aafTaxonomyValuesTLA';
	case KCM.ILO
		astrDependencies = tKCM.astrDevelopedKCs;
		astrDependents = tKCM.astrIntendedLearnOutcomes;
		aafWorkingSheet = tKCM.aafTaxonomyValuesILO;
	otherwise
		error('Unexpected KCM sheet ID %d.', iType);
end
aabConnections = aafWorkingSheet > 0;
[aiRows, aiCols] = ind2sub(size(aafWorkingSheet), find(aabConnections));
tabRelations = table(astrDependencies(aiCols), astrDependents(aiRows),...
			aafWorkingSheet(aabConnections), 'VariableNames',...
			KCM.ASTR_HEADERS_ADJ);
end