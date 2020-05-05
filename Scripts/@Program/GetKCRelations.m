function tabLinks = GetKCRelations(tProgram)
%
% Get the KCs in alphabetic order
astrKCs = sort([tProgram.tProgramKCM.astrPrerequisiteKCs
			tProgram.tProgramKCM.astrDevelopedKCs]);
[atKCMs, aaiTypes] = tProgram.GetCoursesByKC(astrKCs);
%
% Column names
astrHeaders = arrayfun(@(t) t.strCourseCode, tProgram.atKCMs(1:end-2),...
	'UniformOutput', false);
%
% Get the numbers
aastrTypes = cellfun(@(t) string(split(t, '  ')), ...
		cellfun(@num2str, aaiTypes, 'UniformOutput', false), ...
		'UniformOutput', false);
[~, aaiWhichCols] = cellfun(@(t) ismember({t.strCourseCode}', astrHeaders),...
	atKCMs, 'UniformOutput', false);
%
% Ready the table matrix
aastrTableData = strings(numel(astrKCs), numel(astrHeaders));
%
% Indexing matters
aiRows = arrayfun(@(i) repmat(i, numel(aaiTypes{i}), 1), 1:numel(aaiTypes),...
	'UniformOutput', false);
aiRows = vertcat(aiRows{:});
aiInds = sub2ind(size(aastrTableData), aiRows, vertcat(aaiWhichCols{:}));
%
% Insert prerequisite/developed entries
aastrTableData(aiInds) = vertcat(aastrTypes{:});
aastrTableData(strcmp(aastrTableData, "1")) = "P"; % Should not be hard-coded
aastrTableData(strcmp(aastrTableData, "2")) = "D";
%
% Create the table
tabLinks = table('Size', [numel(astrKCs) numel(astrHeaders)],...
	'VariableTypes', repmat("string", numel(astrHeaders), 1),...
	'RowNames', astrKCs, 'VariableNames', genvarname(astrHeaders));
tabLinks(:, :) = num2cell(aastrTableData);
end